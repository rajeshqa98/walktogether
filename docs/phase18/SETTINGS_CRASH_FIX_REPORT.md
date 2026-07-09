# WalkTogether — Settings Crash Fix Report

**Phase:** 18B
**Status:** ✅ Fixed
**Root cause:** Missing `cn` import + SQLite read-only database

---

## 1. Problem

The Settings screen crashed with a client-side error:
> "Application error: a client-side exception has occurred while loading localhost"

The error stack pointed to `Settings.tsx (456:32)` and `Settings.tsx (439:36)`, which corresponded to the language picker's `LANGUAGES_WITH_META.map()` call and the `cn()` className helper.

---

## 2. Root Cause

### Primary cause: Missing `cn` import

The Settings component used the `cn()` utility function in the language picker's button className:

```tsx
className={cn(
  "w-full flex items-center justify-between gap-2 rounded-lg border px-3 py-2 text-left transition-colors",
  isActive ? "border-primary bg-primary/5" : "border-border bg-card hover:bg-muted/50"
)}
```

But `cn` was never imported:

```tsx
// Missing:
import { cn } from "@/lib/utils";
```

This caused a `ReferenceError: cn is not defined` at runtime when the language picker rendered.

### Secondary cause: SQLite read-only database

During Phase 18 testing, the SQLite database became read-only (likely due to a filesystem issue), causing demo user login to fail. This meant the `me` object was null, which could also cause Settings to crash when accessing `me.language`.

---

## 3. Fix

### Fix 1: Add `cn` import

Added the missing import to `src/components/screens/Settings.tsx`:

```tsx
import { cn } from "@/lib/utils";
```

### Fix 2: Restart dev server

Restarted the dev server to restore SQLite write access. The database file permissions were verified:
- `db/custom.db` is writable by the `z` user
- `db/` directory is writable (needed for SQLite WAL/journal files)

---

## 4. Verification

After the fix:

1. ✅ Demo user login works (database is writable)
2. ✅ Settings screen loads without crash
3. ✅ Language picker renders all 9 languages with native names, beta badges, RTL badges, and completeness percentages
4. ✅ Selecting a language saves to backend and applies immediately
5. ✅ Community section works (Your area, First walker flow, Become a Host, Share WalkTogether)
6. ✅ Privacy/legal links work
7. ✅ Notification settings (switches) work
8. ✅ Feedback button works
9. ✅ Logout button works
10. ✅ No console errors

---

## 5. Prevention

To prevent similar issues in the future:

1. **Lint catches unused imports but not missing imports** — The `cn` function was used but not imported. ESLint didn't catch this because `cn` is a valid global-like name. Consider adding a custom ESLint rule to flag undefined function calls.

2. **Always test after refactoring** — The language picker was refactored from a `<select>` to a button-based list, which introduced the `cn` usage. The refactor should have been tested immediately.

3. **Database health check** — Add a `/api/health` check that verifies database write access, not just read access.

---

## 6. Acceptance Criteria

- [x] Settings screen loads without client-side error
- [x] Language picker works (all 9 languages selectable)
- [x] Community section works
- [x] Privacy/legal links work
- [x] Notification settings work
- [x] Feedback button works
- [x] Logout works
- [x] No console errors
