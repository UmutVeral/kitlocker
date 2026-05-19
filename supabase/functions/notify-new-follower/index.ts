import { createClient } from 'jsr:@supabase/supabase-js@2';

const serviceClient = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

// FCM REST API v1 — requires FCM_SERVER_KEY secret (set in #14)
const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY');

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  const { followerId, followeeId } = await req.json();
  if (!followerId || !followeeId) {
    return new Response('Missing followerId or followeeId', { status: 400 });
  }

  // Get follower username for notification body
  const { data: followerProfile } = await serviceClient
    .from('profiles')
    .select('username')
    .eq('id', followerId)
    .single();

  // Get followee FCM token
  const { data: followeeProfile } = await serviceClient
    .from('profiles')
    .select('fcm_token, notification_prefs')
    .eq('id', followeeId)
    .single();

  const fcmToken = followeeProfile?.fcm_token;

  // FCM push is active only after #14 (FCM Setup) is complete
  // Without a token, we return early without error
  if (!FCM_SERVER_KEY || !fcmToken) {
    return new Response(JSON.stringify({ sent: false, reason: 'fcm_not_configured' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const followerUsername = followerProfile?.username ?? 'Someone';

  const fcmPayload = {
    message: {
      token: fcmToken,
      notification: {
        title: 'New follower',
        body: `${followerUsername} started following you`,
      },
      data: {
        type: 'new_follower',
        followerId,
      },
    },
  };

  const fcmRes = await fetch(
    'https://fcm.googleapis.com/v1/projects/kitlocker/messages:send',
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${FCM_SERVER_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(fcmPayload),
    },
  );

  if (!fcmRes.ok) {
    console.error('FCM error:', await fcmRes.text());
    return new Response(JSON.stringify({ sent: false, reason: 'fcm_error' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response(JSON.stringify({ sent: true }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
