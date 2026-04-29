-- ══════════════════════════════════════════
-- HI Members — Initial Schema
-- ══════════════════════════════════════════

-- ── members ────────────────────────────────
create table if not exists public.members (
  id                uuid primary key default gen_random_uuid(),
  name              text not null,
  phone             text not null,
  graduation_date   date,
  membership_agree  boolean not null default false,
  benefit_1         boolean not null default false,  -- 연 2회 이벤트
  benefit_2         boolean not null default false,  -- 지인 추천 리워드
  benefit_3         boolean not null default false,  -- 가족 사진 촬영
  benefit_4         boolean not null default false,  -- 임신·출산 소식 공유
  medical_consent   text not null default 'pending', -- 'agree' | 'disagree'
  inquiry           text,
  status            text not null default 'pending', -- 'pending' | 'approved' | 'rejected'
  admin_note        text,
  created_at        timestamptz not null default now()
);

create index if not exists members_phone_idx on public.members (phone);
create index if not exists members_status_idx on public.members (status);
create index if not exists members_created_at_idx on public.members (created_at desc);

alter table public.members disable row level security;
grant select, insert, update, delete on public.members to anon, authenticated, service_role;

-- ── app_config ─────────────────────────────
create table if not exists public.app_config (
  key        text primary key,
  value      text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.app_config disable row level security;
grant select, insert, update on public.app_config to anon, authenticated, service_role;

-- 기본 관리자 핀코드 (Supabase 대시보드에서 변경하세요)
insert into public.app_config (key, value)
values ('admin_pin', '0000')
on conflict (key) do nothing;
