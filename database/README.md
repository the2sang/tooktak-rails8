# tooktak 시공관리플랫폼 — PostgreSQL DB

## 파일 구조

```
database/
├── migrations/
│   └── 001_schema.sql       # 전체 스키마 (테이블, 인덱스, 트리거)
├── seeds/
│   └── 001_seed_data.sql    # 샘플 데이터
└── README.md
```

## 빠른 시작

```bash
# 1. DB 생성
createdb tooktak

# 2. 스키마 적용
psql -d tooktak -f database/migrations/001_schema.sql

# 3. 샘플 데이터 삽입
psql -d tooktak -f database/seeds/001_seed_data.sql
```

## 테이블 목록 (22개)

| 테이블 | 설명 | Firebase 경로 |
|--------|------|--------------|
| `companies` | 회사 (원도급, 하도급, 발주처) | `companies/` |
| `users` | 사용자 | `users/` |
| `projects` | 공사 프로젝트 | `projects/` |
| `project_members` | 프로젝트 참여자 | `projects/{id}/members/` |
| `subcontracts` | 하도급 계약 | `projects/{id}/subcontracts/` |
| `work_categories` | 공종 카테고리 | `work_categories/` |
| `work_orders` | 작업지시서 | `projects/{id}/work_orders/` |
| `daily_reports` | 작업일보 | `projects/{id}/daily_reports/` |
| `daily_report_items` | 일보 세부항목 | `projects/{id}/daily_reports/{id}/work_items/` |
| `schedules` | 공정표 | `projects/{id}/schedules/` |
| `schedule_items` | 공정표 항목 (WBS) | `projects/{id}/schedules/{id}/items/` |
| `workers` | 현장 근로자 | `workers/` |
| `attendance` | 출역 기록 | `projects/{id}/attendance/` |
| `materials` | 자재 마스터 | `materials/` |
| `material_orders` | 자재 발주/입출고 | `projects/{id}/material_orders/` |
| `inspection_templates` | 검사 체크리스트 템플릿 | `inspection_templates/` |
| `inspections` | 검사 기록 | `projects/{id}/inspections/` |
| `issues` | 이슈/하자 | `projects/{id}/issues/` |
| `issue_comments` | 이슈 댓글 | `projects/{id}/issues/{id}/comments/` |
| `safety_checks` | 안전점검 | `projects/{id}/safety_checks/` |
| `costs` | 비용 항목 | `projects/{id}/costs/` |
| `billings` | 기성 청구 | `projects/{id}/billing/` |
| `documents` | 문서/파일 | `projects/{id}/documents/` |
| `notifications` | 알림 | `notifications/` |
| `audit_logs` | 감사 로그 | `audit_logs/` |

## 샘플 데이터 구성

- **회사** 6개 (원도급 2, 하도급 2, 발주처 1, 자재사 1)
- **사용자** 7명 (admin, manager, supervisor, worker, client)
- **프로젝트** 3개 (진행중 2, 완료 1)
- **작업지시서** 4건
- **이슈/하자** 3건
- **검사** 2건
- **일보** 2건
- **자재/발주** 5종 / 3건
- **출역기록** 5건
- **기성청구** 3건
