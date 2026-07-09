// WalkTogether — Minimal Backend for Local Beta Testing
// 100% free • safety-first • community-first
// No payments, no subscriptions, no premium features, no ads
//
// This is a MINIMAL backend that matches the exact API routes
// called by the Flutter app. It uses in-memory storage (no database)
// for local testing. For production, use the full Next.js backend.
//
// Run: npm install && node server.js
// Port: 3000
// OTP: 123456 (dev mode — always returns this code)

const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const crypto = require('crypto');

const app = express();
const PORT = 3000;

// ===== Middleware =====
app.use(cors({ origin: true, credentials: true }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// ===== In-Memory Storage =====
const users = new Map();      // phone -> user object
const sessions = new Map();   // sessionToken -> phone
const otpStore = new Map();   // phone -> { code, expires, attempts }
const walkRequests = new Map();
const sessions_store = new Map();
const messages = new Map();   // requestId -> [messages]
const blocks = new Map();     // userId -> [blockedUserIds]
const reports = new Map();
const groupWalks = new Map();
const clubs = new Map();
const notifications = new Map();
const feedback = new Map();
const privacyRequests = new Map();
const appeals = new Map();
const pushSubscriptions = new Map();

// ===== Helpers =====
const DEV_OTP = '123456';
const SESSION_COOKIE = 'next-auth.session-token';

function generateToken() {
  return crypto.randomBytes(32).toString('hex');
}

function getSessionPhone(req) {
  const token = req.cookies[SESSION_COOKIE] ||
    (req.headers.cookie || '').match(new RegExp(SESSION_COOKIE + '=([^;]+)'))?.[1];
  if (!token) return null;
  return sessions.get(token) || null;
}

function getUserByPhone(phone) {
  return users.get(phone);
}

function getOrCreateUser(phone) {
  if (!users.has(phone)) {
    const id = 'user_' + crypto.randomBytes(8).toString('hex');
    users.set(phone, {
      id,
      phone,
      name: 'Walker',
      ageRange: '25-34',
      gender: 'female',
      bio: null,
      city: null,
      neighborhood: null,
      village: null,
      town: null,
      district: null,
      stateRegion: null,
      countryCode: null,
      language: 'en',
      verificationStatus: 'unverified',
      trustScore: 50,
      completedWalks: 0,
      isNewUser: true,
      hideMe: false,
      isOnline: true,
      role: 'user',
      status: 'active',
      statusReason: null,
      isCommunityHost: false,
      createdAt: new Date().toISOString(),
    });
  }
  return users.get(phone);
}

// ===== Health Check =====
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/api/ready', (req, res) => {
  res.json({ status: 'ready' });
});

// ===== Auth — CSRF (NextAuth compatibility) =====
app.get('/api/auth/csrf', (req, res) => {
  const csrfToken = crypto.randomBytes(16).toString('hex');
  res.json({ csrfToken });
});

// ===== Auth — OTP Request =====
app.post('/api/auth/otp/request', (req, res) => {
  const { phone } = req.body;
  if (!phone) {
    return res.status(400).json({ error: 'Phone number required' });
  }

  // Dev mode: always use 123456, return it in response
  otpStore.set(phone, {
    code: DEV_OTP,
    expires: Date.now() + 5 * 60 * 1000,
    attempts: 0,
  });

  console.log(`[OTP] Phone: ${phone}, Dev OTP: ${DEV_OTP}`);

  res.json({
    ok: true,
    devCode: DEV_OTP, // Only in dev mode
    resendCooldownMs: 30000,
    message: 'OTP sent (dev mode: use 123456)',
  });
});

// ===== Auth — OTP Verify =====
app.post('/api/auth/otp/verify', (req, res) => {
  const { phone, code } = req.body;
  if (!phone || !code) {
    return res.status(400).json({ error: 'Phone and code required' });
  }

  const stored = otpStore.get(phone);
  if (!stored) {
    return res.status(400).json({ error: 'No OTP requested for this number' });
  }

  if (stored.code !== code) {
    stored.attempts++;
    if (stored.attempts >= 5) {
      otpStore.delete(phone);
      return res.status(429).json({ error: 'Too many attempts. Request new OTP.' });
    }
    return res.status(400).json({ error: 'Invalid OTP code' });
  }

  // OTP verified — clear it
  otpStore.delete(phone);

  // Get or create user
  const user = getOrCreateUser(phone);

  res.json({ ok: true, verified: true, userId: user.id });
});

// ===== Auth — NextAuth Callback (phone-otp) =====
app.post('/api/auth/callback/phone-otp', (req, res) => {
  const { phone, otp } = req.body;

  if (!phone || !otp) {
    return res.status(400).json({ error: 'Phone and OTP required' });
  }

  // Verify OTP
  const stored = otpStore.get(phone);
  if (!stored || stored.code !== otp) {
    // In dev mode, accept 123456 even if not requested
    if (otp !== DEV_OTP) {
      return res.status(400).json({ error: 'Invalid OTP' });
    }
  }

  // Clear OTP
  if (stored) otpStore.delete(phone);

  // Get or create user
  const user = getOrCreateUser(phone);

  // Create session
  const sessionToken = generateToken();
  sessions.set(sessionToken, phone);

  // Set cookie
  res.setHeader('Set-Cookie', `${SESSION_COOKIE}=${sessionToken}; Path=/; HttpOnly; Max-Age=2592000`);

  res.json({ ok: true, url: '/' });
});

// ===== Auth — Logout =====
app.post('/api/auth/logout', (req, res) => {
  const token = req.cookies[SESSION_COOKIE];
  if (token) sessions.delete(token);
  res.setHeader('Set-Cookie', `${SESSION_COOKIE}=; Path=/; Max-Age=0`);
  res.json({ ok: true });
});

// ===== User — Get Me =====
app.get('/api/me', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'User not found' });

  res.json(user);
});

// ===== User — Update Me =====
app.patch('/api/me', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'User not found' });

  // Update allowed fields
  const allowed = ['name', 'ageRange', 'gender', 'bio', 'city', 'neighborhood',
    'village', 'town', 'district', 'stateRegion', 'countryCode', 'language',
    'hideMe', 'isNewUser', 'isCommunityHost'];
  for (const key of allowed) {
    if (req.body[key] !== undefined) {
      user[key] = req.body[key];
    }
  }
  user.updatedAt = new Date().toISOString();

  res.json(user);
});

// ===== Walkers — Nearby =====
app.get('/api/walkers', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const myUser = getUserByPhone(phone);
  const walkers = [];

  for (const [otherPhone, user] of users) {
    if (otherPhone === phone) continue;
    if (user.hideMe) continue;
    if (user.status !== 'active') continue;

    // Return coarse distance only — NEVER exact coordinates
    walkers.push({
      id: user.id,
      name: user.name,
      distance: Math.floor(Math.random() * 900) + 100, // 100-1000m
      trustScore: user.trustScore,
      verificationStatus: user.verificationStatus,
      ageRange: user.ageRange,
      gender: user.gender,
      bio: user.bio,
      completedWalks: user.completedWalks,
      city: user.city,
      neighborhood: user.neighborhood,
    });
  }

  res.json(walkers);
});

// ===== Walk Requests =====
app.get('/api/requests', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const incoming = [];
  const outgoing = [];

  for (const [id, req] of walkRequests) {
    const sender = users.get(req.senderPhone);
    const receiver = users.get(req.receiverPhone);
    const reqData = {
      id,
      ...req,
      sender: sender ? { id: sender.id, name: sender.name, verificationStatus: sender.verificationStatus } : null,
      receiver: receiver ? { id: receiver.id, name: receiver.name, verificationStatus: receiver.verificationStatus } : null,
      messages: messages.get(id) || [],
    };

    if (req.receiverPhone === phone) incoming.push(reqData);
    if (req.senderPhone === phone) outgoing.push(reqData);
  }

  res.json({ incoming, outgoing });
});

app.post('/api/requests', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const { receiverId, message, walkType } = req.body;

  // Find receiver by ID
  let receiverPhone = null;
  for (const [p, u] of users) {
    if (u.id === receiverId) { receiverPhone = p; break; }
  }
  if (!receiverPhone) return res.status(404).json({ error: 'Receiver not found' });

  const id = 'req_' + crypto.randomBytes(8).toString('hex');
  const newReq = {
    id,
    senderPhone: phone,
    receiverPhone,
    senderId: myUser.id,
    receiverId,
    status: 'pending',
    message: message || '',
    walkType: walkType || 'casual',
    createdAt: new Date().toISOString(),
  };
  walkRequests.set(id, newReq);
  messages.set(id, []);

  res.json({ ...newReq, ok: true });
});

app.patch('/api/requests/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const reqData = walkRequests.get(req.params.id);
  if (!reqData) return res.status(404).json({ error: 'Request not found' });

  const { status } = req.body;
  if (!['accepted', 'declined', 'cancelled'].includes(status)) {
    return res.status(400).json({ error: 'Invalid status' });
  }

  reqData.status = status;
  reqData.updatedAt = new Date().toISOString();

  res.json({ ...reqData, ok: true });
});

// ===== Messages =====
app.get('/api/requests/:requestId/messages', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const msgs = messages.get(req.params.requestId) || [];
  res.json(msgs);
});

app.post('/api/requests/:requestId/messages', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const { message } = req.body;
  if (!message) return res.status(400).json({ error: 'Message required' });

  const msg = {
    id: 'msg_' + crypto.randomBytes(8).toString('hex'),
    requestId: req.params.requestId,
    senderId: myUser.id,
    senderPhone: phone,
    message,
    moderationStatus: 'ok',
    createdAt: new Date().toISOString(),
  };

  if (!messages.has(req.params.requestId)) {
    messages.set(req.params.requestId, []);
  }
  messages.get(req.params.requestId).push(msg);

  res.json(msg);
});

// ===== Sessions (Walk Sessions) =====
app.post('/api/sessions', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const { requestId } = req.body;
  const reqData = walkRequests.get(requestId);
  if (!reqData) return res.status(404).json({ error: 'Request not found' });

  const id = 'sess_' + crypto.randomBytes(8).toString('hex');
  const session = {
    id,
    requestId,
    user1Phone: reqData.senderPhone,
    user2Phone: reqData.receiverPhone,
    user1Id: reqData.senderId,
    user2Id: reqData.receiverId,
    startTime: new Date().toISOString(),
    endTime: null,
    status: 'active',
    safetyShared: false,
    sosTriggered: false,
  };
  sessions_store.set(id, session);

  res.json(session);
});

app.get('/api/sessions/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const session = sessions_store.get(req.params.id);
  if (!session) return res.status(404).json({ error: 'Session not found' });

  // Don't expose exact coordinates
  res.json({ ...session, routeSummary: null });
});

app.patch('/api/sessions/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const session = sessions_store.get(req.params.id);
  if (!session) return res.status(404).json({ error: 'Session not found' });

  if (req.body.status) session.status = req.body.status;
  if (session.status === 'ended') session.endTime = new Date().toISOString();

  res.json(session);
});

// ===== SOS =====
app.post('/api/sessions/:sessionId/sos', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const session = sessions_store.get(req.params.sessionId);
  if (!session) return res.status(404).json({ error: 'Session not found' });

  session.sosTriggered = true;
  session.status = 'safety_alert';

  console.log(`[SOS] Triggered by ${phone} in session ${req.params.sessionId}`);
  console.log('[SOS] WalkTogether is NOT an emergency service. User should call local emergency number.');

  res.json({
    ok: true,
    message: 'SOS triggered. Safety team notified.',
    sessionId: req.params.sessionId,
  });
});

// ===== Safety Share =====
app.post('/api/sessions/:sessionId/safety', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const session = sessions_store.get(req.params.sessionId);
  if (!session) return res.status(404).json({ error: 'Session not found' });

  session.safetyShared = req.body.enabled || false;

  res.json({ ok: true, safetyShared: session.safetyShared });
});

// ===== Reports =====
app.post('/api/reports', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const { reportedUserId, reason, evidence } = req.body;
  const id = 'rep_' + crypto.randomBytes(8).toString('hex');
  const report = {
    id,
    reporterPhone: phone,
    reportedUserId,
    reason: reason || 'other',
    evidence: evidence || null,
    status: 'open',
    createdAt: new Date().toISOString(),
  };
  reports.set(id, report);

  console.log(`[REPORT] ${phone} reported user ${reportedUserId}: ${reason}`);

  res.json({ ...report, ok: true });
});

// ===== Blocks =====
app.post('/api/blocks', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const { blockedId } = req.body;
  if (!blockedId) return res.status(400).json({ error: 'blockedId required' });

  if (!blocks.has(myUser.id)) blocks.set(myUser.id, []);
  if (!blocks.get(myUser.id).includes(blockedId)) {
    blocks.get(myUser.id).push(blockedId);
  }

  res.json({ ok: true, blockedId });
});

app.get('/api/blocks', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const blockedIds = blocks.get(myUser.id) || [];
  const blockedUsers = blockedIds.map(id => {
    for (const [p, u] of users) {
      if (u.id === id) return { id: u.id, name: u.name, phone: p };
    }
    return { id, name: 'Unknown', phone: null };
  });

  res.json(blockedUsers);
});

app.delete('/api/blocks/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const blockedIds = blocks.get(myUser.id) || [];
  const idx = blockedIds.indexOf(req.params.id);
  if (idx >= 0) blockedIds.splice(idx, 1);

  res.json({ ok: true });
});

// ===== Notifications =====
app.get('/api/notifications', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const notifs = notifications.get(phone) || [];
  res.json({ notifications: notifs });
});

app.post('/api/notifications/read-all', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const notifs = notifications.get(phone) || [];
  for (const n of notifs) n.readAt = new Date().toISOString();

  res.json({ ok: true });
});

// ===== Push Subscriptions =====
app.post('/api/me/push-subscription', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const { endpoint } = req.body;
  if (!pushSubscriptions.has(phone)) pushSubscriptions.set(phone, []);
  pushSubscriptions.get(phone).push({ endpoint, createdAt: new Date().toISOString() });

  res.json({ ok: true });
});

app.delete('/api/me/push-subscription', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  pushSubscriptions.set(phone, []);
  res.json({ ok: true });
});

// ===== Group Walks =====
app.get('/api/group-walks', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const walks = Array.from(groupWalks.values()).map(w => ({
    ...w,
    hasJoined: w.participants?.includes(phone) || false,
    isHost: w.hostPhone === phone,
  }));

  res.json({ walks });
});

app.get('/api/group-walks/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const walk = groupWalks.get(req.params.id);
  if (!walk) return res.status(404).json({ error: 'Not found' });

  res.json({
    walk: {
      ...walk,
      hasJoined: walk.participants?.includes(phone) || false,
      isHost: walk.hostPhone === phone,
    }
  });
});

app.post('/api/group-walks', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const id = 'gw_' + crypto.randomBytes(8).toString('hex');
  const walk = {
    id,
    title: req.body.title || 'Group Walk',
    description: req.body.description || null,
    hostPhone: phone,
    hostName: myUser.name,
    hostVerified: myUser.verificationStatus === 'verified',
    city: req.body.city || myUser.city || 'Unknown',
    neighborhood: req.body.neighborhood || null,
    meetingPointName: req.body.meetingPointName || 'TBD',
    scheduledAt: req.body.scheduledAt || new Date(Date.now() + 86400000).toISOString(),
    maxParticipants: req.body.maxParticipants || 10,
    currentParticipants: 1,
    status: 'scheduled',
    visibility: req.body.visibility || 'public',
    pace: req.body.pace || 'normal',
    walkType: req.body.walkType || 'casual',
    participants: [phone],
    createdAt: new Date().toISOString(),
  };
  groupWalks.set(id, walk);

  res.json({ ...walk, ok: true });
});

app.post('/api/group-walks/:id/join', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const walk = groupWalks.get(req.params.id);
  if (!walk) return res.status(404).json({ error: 'Not found' });

  if (!walk.participants.includes(phone)) {
    walk.participants.push(phone);
    walk.currentParticipants = walk.participants.length;
  }

  res.json({ ok: true });
});

app.post('/api/group-walks/:id/leave', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const walk = groupWalks.get(req.params.id);
  if (!walk) return res.status(404).json({ error: 'Not found' });

  walk.participants = walk.participants.filter(p => p !== phone);
  walk.currentParticipants = walk.participants.length;

  res.json({ ok: true });
});

app.get('/api/group-walks/:id/messages', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const msgs = messages.get('gw_' + req.params.id) || [];
  res.json({ messages: msgs });
});

app.post('/api/group-walks/:id/messages', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const key = 'gw_' + req.params.id;
  if (!messages.has(key)) messages.set(key, []);

  const msg = {
    id: 'gmsg_' + crypto.randomBytes(8).toString('hex'),
    groupWalkId: req.params.id,
    senderId: myUser.id,
    senderName: myUser.name,
    message: req.body.message || '',
    isAnnouncement: req.body.isAnnouncement || false,
    moderationStatus: 'ok',
    createdAt: new Date().toISOString(),
  };
  messages.get(key).push(msg);

  res.json(msg);
});

app.get('/api/group-walks/:id/participants', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const walk = groupWalks.get(req.params.id);
  if (!walk) return res.status(404).json({ error: 'Not found' });

  const participants = walk.participants.map(p => {
    const u = users.get(p);
    return u ? { id: u.id, name: u.name, verificationStatus: u.verificationStatus } : null;
  }).filter(Boolean);

  res.json({ participants });
});

// ===== Clubs =====
app.get('/api/clubs', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const clubList = Array.from(clubs.values()).map(c => ({
    ...c,
    hasJoined: c.members?.includes(phone) || false,
  }));

  res.json({ clubs: clubList });
});

app.get('/api/clubs/:id', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const club = clubs.get(req.params.id);
  if (!club) return res.status(404).json({ error: 'Not found' });

  res.json({
    club: {
      ...club,
      hasJoined: club.members?.includes(phone) || false,
      isCreator: club.creatorPhone === phone,
    }
  });
});

app.post('/api/clubs', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });
  const myUser = getUserByPhone(phone);

  const id = 'club_' + crypto.randomBytes(8).toString('hex');
  const club = {
    id,
    name: req.body.name || 'Walking Club',
    description: req.body.description || null,
    clubType: req.body.clubType || 'morning_walkers',
    city: req.body.city || myUser.city || 'Unknown',
    neighborhood: req.body.neighborhood || null,
    visibility: req.body.visibility || 'public',
    status: 'active',
    creatorPhone: phone,
    memberCount: 1,
    members: [phone],
    createdAt: new Date().toISOString(),
  };
  clubs.set(id, club);

  res.json({ ...club, ok: true });
});

app.post('/api/clubs/:id/join', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const club = clubs.get(req.params.id);
  if (!club) return res.status(404).json({ error: 'Not found' });

  if (!club.members.includes(phone)) {
    club.members.push(phone);
    club.memberCount = club.members.length;
  }

  res.json({ ok: true });
});

app.post('/api/clubs/:id/leave', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const club = clubs.get(req.params.id);
  if (!club) return res.status(404).json({ error: 'Not found' });

  club.members = club.members.filter(p => p !== phone);
  club.memberCount = club.members.length;

  res.json({ ok: true });
});

app.get('/api/clubs/:id/walks', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  res.json({ walks: [] });
});

// ===== Feedback =====
app.post('/api/feedback', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const id = 'fb_' + crypto.randomBytes(8).toString('hex');
  const fb = {
    id,
    userPhone: phone,
    category: req.body.category || 'general',
    rating: req.body.rating || 5,
    message: req.body.message || '',
    status: 'new',
    createdAt: new Date().toISOString(),
  };
  feedback.set(id, fb);

  console.log(`[FEEDBACK] ${phone}: ${fb.category} — ${fb.message.substring(0, 50)}`);

  res.json({ ...fb, ok: true });
});

// ===== Privacy Requests =====
app.get('/api/privacy-requests', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const userReqs = [];
  for (const [id, pr] of privacyRequests) {
    if (pr.userPhone === phone) userReqs.push(pr);
  }

  res.json({ requests: userReqs });
});

app.post('/api/privacy-requests', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const id = 'pr_' + crypto.randomBytes(8).toString('hex');
  const pr = {
    id,
    userPhone: phone,
    requestType: req.body.requestType || 'data_export',
    details: req.body.details || null,
    status: 'submitted',
    dueAt: new Date(Date.now() + 7 * 86400000).toISOString(),
    createdAt: new Date().toISOString(),
  };
  privacyRequests.set(id, pr);

  res.json({ ...pr, ok: true });
});

app.patch('/api/privacy-requests', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const { id, action } = req.body;
  const pr = privacyRequests.get(id);
  if (!pr || pr.userPhone !== phone) return res.status(404).json({ error: 'Not found' });

  if (action === 'cancel') pr.status = 'cancelled';

  res.json({ ...pr, ok: true });
});

// ===== Account Deletion =====
app.get('/api/me/deletion', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  const isPending = user?.statusReason?.includes('deletion');

  res.json({
    deletionRequest: isPending ? {
      status: 'pending_grace',
      graceEndsAt: new Date(Date.now() + 14 * 86400000).toISOString(),
      reason: user.statusReason,
    } : null,
    gracePeriodDays: 14,
  });
});

app.post('/api/me/deletion', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'Not found' });

  user.hideMe = true;
  user.isOnline = false;
  user.statusReason = 'User requested account deletion — in grace period';

  console.log(`[DELETION] ${phone} started 14-day grace period`);

  res.json({ ok: true, message: 'Account deletion scheduled. 14-day grace period started.' });
});

app.delete('/api/me/deletion', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'Not found' });

  user.hideMe = false;
  user.isOnline = true;
  user.statusReason = null;

  console.log(`[DELETION] ${phone} cancelled deletion`);

  res.json({ ok: true, message: 'Account deletion cancelled.' });
});

// ===== Data Export =====
app.get('/api/me/export', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'Not found' });

  // Partially redact phone number for privacy
  const redactedPhone = phone.length > 6
    ? phone.slice(0, 3) + '*****' + phone.slice(-4)
    : '<redacted>';

  res.json({
    exportMetadata: {
      exportedAt: new Date().toISOString(),
      userId: user.id,
      schema: 'walktogether-user-export-v1',
      note: 'WalkTogether honors your privacy. Other users\' private data is excluded.',
    },
    profile: {
      ...user,
      phone: redactedPhone,
    },
    dataExclusions: [
      'Other users\' phone numbers, emails, and exact coordinates',
      'Admin notes on reports, appeals, and feedback',
      'Internal moderation notes',
      'Admin-only safety intelligence',
    ],
  });
});

// ===== Appeals =====
app.get('/api/appeals', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const userAppeals = [];
  for (const [id, a] of appeals) {
    if (a.userPhone === phone) userAppeals.push(a);
  }

  res.json({ appeals: userAppeals });
});

app.post('/api/appeals', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const id = 'ap_' + crypto.randomBytes(8).toString('hex');
  const appeal = {
    id,
    userPhone: phone,
    actionType: req.body.actionType || 'account_suspension',
    reason: req.body.reason || '',
    explanation: req.body.explanation || '',
    status: 'submitted',
    createdAt: new Date().toISOString(),
  };
  appeals.set(id, appeal);

  console.log(`[APPEAL] ${phone} submitted appeal: ${appeal.actionType}`);

  res.json({ ...appeal, ok: true });
});

// ===== Area =====
app.get('/api/area', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  res.json({
    areaSlug: 'local',
    walkersNearby: users.size - 1,
    totalUsers: users.size,
    groupWalksCount: groupWalks.size,
    clubsCount: clubs.size,
    recommendation: users.size > 1 ? 'active_community' : 'first_walker',
    safetyConcernLevel: 'green',
  });
});

// ===== Host Onboarding =====
app.post('/api/host/onboard', (req, res) => {
  const phone = getSessionPhone(req);
  if (!phone) return res.status(401).json({ error: 'Unauthorized' });

  const user = getUserByPhone(phone);
  if (!user) return res.status(404).json({ error: 'Not found' });

  user.isCommunityHost = true;
  user.hostOnboardedAt = new Date().toISOString();
  if (req.body.bio) user.bio = req.body.bio;
  if (req.body.village) user.village = req.body.village;
  if (req.body.landmark) user.landmark = req.body.landmark;

  console.log(`[HOST] ${phone} became a community host`);

  res.json({ ...user, ok: true });
});

// ===== Catch-all (for any unmatched routes) =====
app.use((req, res) => {
  console.log(`[404] ${req.method} ${req.path}`);
  res.status(404).json({ error: 'Not found', path: req.path, method: req.method });
});

// ===== Start Server =====
app.listen(PORT, '0.0.0.0', () => {
  console.log('');
  console.log('========================================');
  console.log('  WalkTogether Backend (Minimal Dev)');
  console.log('  100% free • safety-first • community-first');
  console.log('========================================');
  console.log('');
  console.log(`  Server: http://0.0.0.0:${PORT}`);
  console.log(`  Health: http://localhost:${PORT}/api/health`);
  console.log(`  OTP:    123456 (dev mode)`);
  console.log('');
  console.log('  Available on your Wi-Fi:');
  console.log('  Try: curl http://192.168.1.5:3000/api/health');
  console.log('');
  console.log('  No payments. No subscriptions. No ads.');
  console.log('  Safety is not a paid feature — it is a right.');
  console.log('');
});
