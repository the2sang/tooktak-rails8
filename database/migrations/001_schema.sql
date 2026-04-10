-- ============================================================
-- tooktak 시공관리플랫폼 PostgreSQL Schema
-- Firebase → PostgreSQL Migration
-- ============================================================

-- 확장 모듈
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUM 타입 정의
-- ============================================================

CREATE TYPE user_role AS ENUM ('admin', 'manager', 'supervisor', 'worker', 'client');
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'pending', 'suspended');

CREATE TYPE company_type AS ENUM ('general_contractor', 'subcontractor', 'supplier', 'client', 'consultant');

CREATE TYPE project_status AS ENUM ('planning', 'bidding', 'contracted', 'in_progress', 'on_hold', 'completed', 'cancelled');
CREATE TYPE project_type AS ENUM ('new_construction', 'renovation', 'repair', 'interior', 'civil', 'mechanical', 'electrical', 'plumbing', 'other');

CREATE TYPE work_order_status AS ENUM ('draft', 'pending', 'approved', 'in_progress', 'completed', 'rejected', 'cancelled');
CREATE TYPE work_order_priority AS ENUM ('low', 'medium', 'high', 'urgent');

CREATE TYPE inspection_status AS ENUM ('scheduled', 'in_progress', 'passed', 'failed', 'conditionally_passed');
CREATE TYPE inspection_type AS ENUM ('pre_work', 'in_progress', 'final', 'safety', 'quality', 'defect');

CREATE TYPE issue_status AS ENUM ('open', 'in_progress', 'resolved', 'closed', 'rejected');
CREATE TYPE issue_severity AS ENUM ('critical', 'major', 'minor', 'trivial');

CREATE TYPE material_status AS ENUM ('planned', 'ordered', 'delivered', 'in_use', 'consumed', 'returned', 'wasted');
CREATE TYPE document_type AS ENUM ('blueprint', 'specification', 'contract', 'permit', 'report', 'photo', 'video', 'other');

CREATE TYPE payment_status AS ENUM ('pending', 'partial', 'paid', 'overdue', 'cancelled');
CREATE TYPE cost_category AS ENUM ('labor', 'material', 'equipment', 'subcontract', 'overhead', 'other');

CREATE TYPE schedule_status AS ENUM ('not_started', 'in_progress', 'completed', 'delayed', 'cancelled');
CREATE TYPE notification_type AS ENUM ('info', 'warning', 'alert', 'approval_request', 'status_change');

-- ============================================================
-- 1. 사용자 & 조직 관리
-- ============================================================

-- 회사 (Firebase: companies/)
CREATE TABLE companies (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(200) NOT NULL,
    business_no     VARCHAR(20) UNIQUE,              -- 사업자번호
    company_type    company_type NOT NULL DEFAULT 'general_contractor',
    ceo_name        VARCHAR(100),
    address         TEXT,
    phone           VARCHAR(20),
    email           VARCHAR(200),
    website         VARCHAR(300),
    logo_url        TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 사용자 (Firebase: users/)
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firebase_uid    VARCHAR(128) UNIQUE,             -- Firebase UID (마이그레이션용)
    company_id      UUID REFERENCES companies(id),
    email           VARCHAR(200) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL DEFAULT '',
    name            VARCHAR(100) NOT NULL,
    phone           VARCHAR(20),
    role            user_role NOT NULL DEFAULT 'worker',
    status          user_status NOT NULL DEFAULT 'active',
    avatar_url      TEXT,
    position        VARCHAR(100),                    -- 직책
    department      VARCHAR(100),                    -- 부서
    license_no      VARCHAR(100),                    -- 면허번호
    last_login_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 2. 프로젝트 관리
-- ============================================================

-- 프로젝트 (Firebase: projects/)
CREATE TABLE projects (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_no          VARCHAR(50) UNIQUE NOT NULL,  -- 공사번호
    name                VARCHAR(300) NOT NULL,         -- 공사명
    client_company_id   UUID REFERENCES companies(id), -- 발주처
    contractor_id       UUID REFERENCES companies(id), -- 원도급사
    project_type        project_type NOT NULL DEFAULT 'new_construction',
    status              project_status NOT NULL DEFAULT 'planning',

    -- 위치정보
    address             TEXT,
    latitude            DECIMAL(10, 8),
    longitude           DECIMAL(11, 8),
    site_area           DECIMAL(12, 2),               -- 대지면적(㎡)
    building_area       DECIMAL(12, 2),               -- 건축면적(㎡)
    total_floor_area    DECIMAL(12, 2),               -- 연면적(㎡)
    floors_above        INT,                          -- 지상층수
    floors_below        INT,                          -- 지하층수

    -- 일정
    contract_date       DATE,                         -- 계약일
    start_date          DATE,                         -- 착공일
    planned_end_date    DATE,                         -- 준공예정일
    actual_end_date     DATE,                         -- 실제준공일

    -- 예산
    contract_amount     BIGINT,                       -- 계약금액(원)
    budget_amount       BIGINT,                       -- 예산금액(원)

    -- 진행현황
    progress_rate       DECIMAL(5, 2) DEFAULT 0,      -- 공정률(%)
    manager_id          UUID REFERENCES users(id),    -- 현장소장
    description         TEXT,
    thumbnail_url       TEXT,

    created_by          UUID REFERENCES users(id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 프로젝트 멤버 (Firebase: projects/{id}/members/)
CREATE TABLE project_members (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role            user_role NOT NULL DEFAULT 'worker',
    joined_at       DATE NOT NULL DEFAULT CURRENT_DATE,
    left_at         DATE,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(project_id, user_id)
);

-- 하도급 계약 (Firebase: projects/{id}/subcontracts/)
CREATE TABLE subcontracts (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id          UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    subcontractor_id    UUID NOT NULL REFERENCES companies(id),
    contract_no         VARCHAR(100),
    work_scope          TEXT NOT NULL,               -- 공사범위
    contract_amount     BIGINT NOT NULL,             -- 계약금액
    start_date          DATE,
    end_date            DATE,
    status              project_status NOT NULL DEFAULT 'contracted',
    manager_id          UUID REFERENCES users(id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 3. 공정 & 작업 관리
-- ============================================================

-- 공정 카테고리 (Firebase: work_categories/)
CREATE TABLE work_categories (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id       UUID REFERENCES work_categories(id),
    name            VARCHAR(200) NOT NULL,
    code            VARCHAR(50) UNIQUE,
    description     TEXT,
    sort_order      INT DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 작업지시서 (Firebase: projects/{id}/work_orders/)
CREATE TABLE work_orders (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_no        VARCHAR(100) UNIQUE NOT NULL,    -- 지시서번호
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    category_id     UUID REFERENCES work_categories(id),
    title           VARCHAR(300) NOT NULL,
    description     TEXT,
    location        VARCHAR(300),                    -- 작업위치 (예: B1F, 1F-101호)
    floor           VARCHAR(50),                     -- 층

    status          work_order_status NOT NULL DEFAULT 'draft',
    priority        work_order_priority NOT NULL DEFAULT 'medium',

    planned_start   DATE,
    planned_end     DATE,
    actual_start    DATE,
    actual_end      DATE,

    estimated_hours DECIMAL(8, 2),
    actual_hours    DECIMAL(8, 2),

    assigned_to     UUID REFERENCES users(id),       -- 담당자
    created_by      UUID REFERENCES users(id),
    approved_by     UUID REFERENCES users(id),
    approved_at     TIMESTAMPTZ,

    subcontract_id  UUID REFERENCES subcontracts(id),
    parent_order_id UUID REFERENCES work_orders(id), -- 모작업 (계층구조)

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 작업일보 (Firebase: projects/{id}/daily_reports/)
CREATE TABLE daily_reports (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    report_date     DATE NOT NULL,
    weather         VARCHAR(50),                     -- 날씨
    temperature     DECIMAL(5, 1),                   -- 기온(℃)
    work_summary    TEXT,                            -- 작업개요
    progress_notes  TEXT,                            -- 공정현황
    safety_notes    TEXT,                            -- 안전사항
    special_notes   TEXT,                            -- 특이사항
    worker_count    INT DEFAULT 0,                   -- 투입인원
    created_by      UUID NOT NULL REFERENCES users(id),
    approved_by     UUID REFERENCES users(id),
    approved_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(project_id, report_date, created_by)
);

-- 일보 작업내역 (Firebase: projects/{id}/daily_reports/{id}/work_items/)
CREATE TABLE daily_report_items (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id       UUID NOT NULL REFERENCES daily_reports(id) ON DELETE CASCADE,
    work_order_id   UUID REFERENCES work_orders(id),
    category_id     UUID REFERENCES work_categories(id),
    description     TEXT NOT NULL,
    quantity        DECIMAL(12, 2),
    unit            VARCHAR(20),
    worker_count    INT DEFAULT 0,
    progress_rate   DECIMAL(5, 2),                  -- 진행률(%)
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 4. 공정표 (Schedule)
-- ============================================================

-- 공정표 (Firebase: projects/{id}/schedules/)
CREATE TABLE schedules (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name            VARCHAR(200) NOT NULL,
    version         INT NOT NULL DEFAULT 1,
    is_baseline     BOOLEAN DEFAULT false,           -- 기준공정표 여부
    created_by      UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 공정표 항목 (Firebase: projects/{id}/schedules/{id}/items/)
CREATE TABLE schedule_items (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    schedule_id     UUID NOT NULL REFERENCES schedules(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES schedule_items(id),
    work_order_id   UUID REFERENCES work_orders(id),
    category_id     UUID REFERENCES work_categories(id),
    wbs_code        VARCHAR(100),                   -- WBS 코드
    name            VARCHAR(300) NOT NULL,
    level           INT NOT NULL DEFAULT 1,          -- 계층레벨
    sort_order      INT DEFAULT 0,

    planned_start   DATE,
    planned_end     DATE,
    actual_start    DATE,
    actual_end      DATE,
    duration_days   INT,

    status          schedule_status NOT NULL DEFAULT 'not_started',
    progress_rate   DECIMAL(5, 2) DEFAULT 0,
    weight          DECIMAL(6, 3) DEFAULT 0,        -- 가중치(%)

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 5. 인력 관리
-- ============================================================

-- 근로자 (Firebase: workers/)
CREATE TABLE workers (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID REFERENCES users(id),
    company_id      UUID REFERENCES companies(id),
    name            VARCHAR(100) NOT NULL,
    phone           VARCHAR(20),
    id_number       VARCHAR(20),                    -- 주민번호 앞자리 등 (암호화 권장)
    trade           VARCHAR(100),                   -- 직종 (예: 철근공, 목수)
    skill_level     VARCHAR(50),                    -- 숙련도
    license_no      VARCHAR(100),                   -- 자격증번호
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 출역 기록 (Firebase: projects/{id}/attendance/)
CREATE TABLE attendance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    worker_id       UUID NOT NULL REFERENCES workers(id),
    work_date       DATE NOT NULL,
    check_in        TIMESTAMPTZ,
    check_out       TIMESTAMPTZ,
    work_hours      DECIMAL(5, 2),
    daily_wage      BIGINT,                        -- 일당(원)
    work_type       VARCHAR(50),                   -- 정규/야간/특근
    recorded_by     UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(project_id, worker_id, work_date)
);

-- ============================================================
-- 6. 자재 관리
-- ============================================================

-- 자재 마스터 (Firebase: materials/)
CREATE TABLE materials (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code            VARCHAR(100) UNIQUE,
    name            VARCHAR(300) NOT NULL,
    category        VARCHAR(100),
    specification   VARCHAR(300),                  -- 규격
    unit            VARCHAR(20) NOT NULL,           -- 단위 (개, kg, m, m², m³ 등)
    unit_price      BIGINT DEFAULT 0,              -- 단가(원)
    supplier_id     UUID REFERENCES companies(id),
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 자재 발주/입출고 (Firebase: projects/{id}/material_orders/)
CREATE TABLE material_orders (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_no        VARCHAR(100) UNIQUE NOT NULL,
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    material_id     UUID NOT NULL REFERENCES materials(id),
    supplier_id     UUID REFERENCES companies(id),

    status          material_status NOT NULL DEFAULT 'planned',

    planned_qty     DECIMAL(12, 2) NOT NULL,        -- 계획수량
    ordered_qty     DECIMAL(12, 2) DEFAULT 0,       -- 발주수량
    delivered_qty   DECIMAL(12, 2) DEFAULT 0,       -- 입고수량
    used_qty        DECIMAL(12, 2) DEFAULT 0,       -- 사용수량

    unit_price      BIGINT,
    total_amount    BIGINT,

    planned_date    DATE,
    order_date      DATE,
    delivery_date   DATE,

    work_order_id   UUID REFERENCES work_orders(id),
    created_by      UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 7. 검사 & 품질 관리
-- ============================================================

-- 검사 체크리스트 템플릿 (Firebase: inspection_templates/)
CREATE TABLE inspection_templates (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(200) NOT NULL,
    category_id     UUID REFERENCES work_categories(id),
    description     TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 체크리스트 항목
CREATE TABLE inspection_template_items (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id     UUID NOT NULL REFERENCES inspection_templates(id) ON DELETE CASCADE,
    sort_order      INT NOT NULL DEFAULT 0,
    item            TEXT NOT NULL,                  -- 검사항목
    criteria        TEXT,                           -- 판정기준
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 검사 기록 (Firebase: projects/{id}/inspections/)
CREATE TABLE inspections (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    work_order_id   UUID REFERENCES work_orders(id),
    template_id     UUID REFERENCES inspection_templates(id),
    inspection_type inspection_type NOT NULL DEFAULT 'in_progress',
    status          inspection_status NOT NULL DEFAULT 'scheduled',
    title           VARCHAR(300) NOT NULL,
    location        VARCHAR(300),
    floor           VARCHAR(50),
    scheduled_date  DATE,
    inspected_date  DATE,
    inspector_id    UUID REFERENCES users(id),
    result_notes    TEXT,
    created_by      UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 검사 항목별 결과
CREATE TABLE inspection_results (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inspection_id   UUID NOT NULL REFERENCES inspections(id) ON DELETE CASCADE,
    template_item_id UUID REFERENCES inspection_template_items(id),
    item            TEXT NOT NULL,
    is_passed       BOOLEAN,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 8. 하자 & 이슈 관리
-- ============================================================

-- 이슈/하자 (Firebase: projects/{id}/issues/)
CREATE TABLE issues (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_no        VARCHAR(100) UNIQUE NOT NULL,
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    work_order_id   UUID REFERENCES work_orders(id),
    category_id     UUID REFERENCES work_categories(id),
    title           VARCHAR(300) NOT NULL,
    description     TEXT,
    location        VARCHAR(300),
    floor           VARCHAR(50),
    status          issue_status NOT NULL DEFAULT 'open',
    severity        issue_severity NOT NULL DEFAULT 'minor',
    reported_by     UUID REFERENCES users(id),
    assigned_to     UUID REFERENCES users(id),
    due_date        DATE,
    resolved_at     TIMESTAMPTZ,
    resolved_by     UUID REFERENCES users(id),
    resolution      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 이슈 댓글 (Firebase: projects/{id}/issues/{id}/comments/)
CREATE TABLE issue_comments (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id        UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
    author_id       UUID NOT NULL REFERENCES users(id),
    content         TEXT NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 9. 안전 관리
-- ============================================================

-- 안전점검 (Firebase: projects/{id}/safety_checks/)
CREATE TABLE safety_checks (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    check_date      DATE NOT NULL,
    checker_id      UUID REFERENCES users(id),
    overall_result  VARCHAR(50),                   -- 양호/주의/불량
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 안전점검 항목
CREATE TABLE safety_check_items (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    check_id        UUID NOT NULL REFERENCES safety_checks(id) ON DELETE CASCADE,
    category        VARCHAR(100),
    item            TEXT NOT NULL,
    result          VARCHAR(50),                   -- 양호/주의/불량/해당없음
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 안전교육 (Firebase: projects/{id}/safety_training/)
CREATE TABLE safety_trainings (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    training_date   DATE NOT NULL,
    title           VARCHAR(300) NOT NULL,
    content         TEXT,
    trainer_id      UUID REFERENCES users(id),
    duration_min    INT,                           -- 교육시간(분)
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 안전교육 참석자
CREATE TABLE safety_training_attendees (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    training_id     UUID NOT NULL REFERENCES safety_trainings(id) ON DELETE CASCADE,
    worker_id       UUID NOT NULL REFERENCES workers(id),
    signed_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(training_id, worker_id)
);

-- ============================================================
-- 10. 비용/정산 관리
-- ============================================================

-- 비용 항목 (Firebase: projects/{id}/costs/)
CREATE TABLE costs (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    category        cost_category NOT NULL DEFAULT 'other',
    work_order_id   UUID REFERENCES work_orders(id),
    subcontract_id  UUID REFERENCES subcontracts(id),
    description     TEXT NOT NULL,
    amount          BIGINT NOT NULL,               -- 금액(원)
    cost_date       DATE NOT NULL,
    invoice_no      VARCHAR(100),
    payment_status  payment_status NOT NULL DEFAULT 'pending',
    paid_at         DATE,
    recorded_by     UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 기성 청구 (Firebase: projects/{id}/billing/)
CREATE TABLE billings (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    billing_no      VARCHAR(100) UNIQUE NOT NULL,
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    billing_month   DATE NOT NULL,                 -- 청구월 (YYYY-MM-01)
    progress_rate   DECIMAL(5, 2) NOT NULL,        -- 기성율(%)
    claim_amount    BIGINT NOT NULL,               -- 청구금액
    approved_amount BIGINT,                        -- 승인금액
    payment_status  payment_status NOT NULL DEFAULT 'pending',
    submitted_at    DATE,
    approved_at     DATE,
    paid_at         DATE,
    created_by      UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 11. 문서 & 파일 관리
-- ============================================================

-- 문서 (Firebase: projects/{id}/documents/ + Storage)
CREATE TABLE documents (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    work_order_id   UUID REFERENCES work_orders(id),
    issue_id        UUID REFERENCES issues(id),
    inspection_id   UUID REFERENCES inspections(id),
    doc_type        document_type NOT NULL DEFAULT 'other',
    title           VARCHAR(300) NOT NULL,
    description     TEXT,
    file_name       VARCHAR(300),
    file_url        TEXT,                          -- Storage URL
    file_size       BIGINT,                        -- bytes
    mime_type       VARCHAR(100),
    version         INT DEFAULT 1,
    uploaded_by     UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 12. 알림 관리
-- ============================================================

-- 알림 (Firebase: notifications/)
CREATE TABLE notifications (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    project_id      UUID REFERENCES projects(id),
    type            notification_type NOT NULL DEFAULT 'info',
    title           VARCHAR(300) NOT NULL,
    body            TEXT,
    link_type       VARCHAR(50),                   -- work_order, issue, inspection 등
    link_id         UUID,                          -- 연결된 레코드 ID
    is_read         BOOLEAN NOT NULL DEFAULT false,
    read_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- FCM 토큰 (Firebase: users/{id}/fcm_tokens/)
CREATE TABLE fcm_tokens (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token           TEXT NOT NULL UNIQUE,
    device_type     VARCHAR(20),                   -- ios, android, web
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 13. 감리/관리 로그
-- ============================================================

-- 변경 이력 (Firebase: audit_logs/)
CREATE TABLE audit_logs (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID REFERENCES users(id),
    project_id      UUID REFERENCES projects(id),
    table_name      VARCHAR(100) NOT NULL,
    record_id       UUID NOT NULL,
    action          VARCHAR(20) NOT NULL,          -- INSERT, UPDATE, DELETE
    old_values      JSONB,
    new_values      JSONB,
    ip_address      INET,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 인덱스
-- ============================================================

-- users
CREATE INDEX idx_users_company ON users(company_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);

-- projects
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_contractor ON projects(contractor_id);
CREATE INDEX idx_projects_client ON projects(client_company_id);
CREATE INDEX idx_projects_manager ON projects(manager_id);

-- project_members
CREATE INDEX idx_project_members_project ON project_members(project_id);
CREATE INDEX idx_project_members_user ON project_members(user_id);

-- work_orders
CREATE INDEX idx_work_orders_project ON work_orders(project_id);
CREATE INDEX idx_work_orders_status ON work_orders(status);
CREATE INDEX idx_work_orders_assigned ON work_orders(assigned_to);
CREATE INDEX idx_work_orders_dates ON work_orders(planned_start, planned_end);

-- daily_reports
CREATE INDEX idx_daily_reports_project_date ON daily_reports(project_id, report_date);

-- inspections
CREATE INDEX idx_inspections_project ON inspections(project_id);
CREATE INDEX idx_inspections_status ON inspections(status);

-- issues
CREATE INDEX idx_issues_project ON issues(project_id);
CREATE INDEX idx_issues_status ON issues(status);
CREATE INDEX idx_issues_assigned ON issues(assigned_to);

-- costs
CREATE INDEX idx_costs_project ON costs(project_id);
CREATE INDEX idx_costs_date ON costs(cost_date);

-- notifications
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE is_read = false;

-- documents
CREATE INDEX idx_documents_project ON documents(project_id);
CREATE INDEX idx_documents_type ON documents(doc_type);

-- attendance
CREATE INDEX idx_attendance_project_date ON attendance(project_id, work_date);
CREATE INDEX idx_attendance_worker ON attendance(worker_id);

-- audit_logs
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);

-- ============================================================
-- updated_at 자동 갱신 트리거
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 적용
DO $$
DECLARE
    t TEXT;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'companies', 'users', 'projects', 'subcontracts', 'work_orders',
        'daily_reports', 'schedules', 'schedule_items', 'workers',
        'materials', 'material_orders', 'inspections', 'issues',
        'issue_comments', 'costs', 'billings', 'documents', 'fcm_tokens'
    ] LOOP
        EXECUTE format(
            'CREATE TRIGGER trg_%s_updated_at
             BEFORE UPDATE ON %I
             FOR EACH ROW EXECUTE FUNCTION update_updated_at()',
            t, t
        );
    END LOOP;
END;
$$;
