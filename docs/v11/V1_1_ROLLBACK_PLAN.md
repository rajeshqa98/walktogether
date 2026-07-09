# WalkTogether — v1.1 Rollback Plan

**Version:** 1.1.0 → Rollback to 1.0.1  
**Trigger:** Critical safety failure, data corruption, or widespread crash after v1.1 deployment

## Rollback Steps

### 1. Backend (No rollback needed)
- v1.1 does NOT change database schema
- v1.1 does NOT change API response formats
- v1.1 only adds Hindi words to moderation list (non-breaking)
- Backend stays on current version

### 2. Web App (PWA)
1. Revert `git checkout v1.0.1` in the web app repository
2. Rebuild: `bun run build`
3. Deploy to Vercel/Render
4. Verify `/api/health` returns 200
5. Verify login + nearby walkers work

### 3. Flutter App (Android)
1. Revert `git checkout v1.0.1` in Flutter app
2. Rebuild: `flutter build appbundle --release`
3. Upload to Google Play as a new release (v1.0.1 build 4)
4. Roll out to 100% immediately
5. Notify users: "We've reverted to v1.0.1 due to a technical issue. v1.1 will return soon."

### 4. Feature Flags (if needed)
- Set `MAINTENANCE_MODE=true` if app is severely broken
- Set `GROUP_CREATION_ENABLED=false` if group walk issue found
- Set `CHAT_ENABLED=false` if chat moderation issue found

## Rollback Decision Matrix

| Issue | Severity | Action |
|-------|----------|--------|
| App crash on launch | P0 | Rollback Flutter app immediately |
| Location privacy leak | P0 | Rollback + investigate + fix before re-release |
| SOS not working | P0 | Rollback Flutter app immediately |
| Chat moderation broken | P1 | Disable chat via flag, investigate |
| Hindi moderation over-blocking | P2 | Remove Hindi words from list, no full rollback |
| UI glitch | P3 | Fix in v1.1.1 hotfix, no rollback |

## Communication Plan
- **P0 rollback:** Email all active users within 1 hour. "We've identified and fixed an issue. Please update to the latest version."
- **P1 rollback:** In-app banner. "We're experiencing issues with [feature]. We're working on it."
- **P2/P3:** Silent fix in next release.

## Post-Rollback Verification
- [ ] /api/health returns 200
- [ ] /api/ready returns 200
- [ ] Login works (OTP + demo)
- [ ] Nearby walkers load
- [ ] Walk request flow works
- [ ] Chat works
- [ ] Walk session + SOS works
- [ ] Group walks work
- [ ] No crash on any core flow
