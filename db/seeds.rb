# frozen_string_literal: true
# tooktak 시공관리플랫폼 시드 데이터
# bin/rails db:seed

puts "Seeding tooktak data..."

# ============================================================
# 1. 회사 데이터
# ============================================================
companies = {
  hankook: Company.find_or_create_by!(business_no: "123-45-67890") { |c|
    c.name = "(주)한국건설"
    c.company_type = :general_contractor
    c.ceo_name = "김건설"
    c.address = "서울특별시 강남구 테헤란로 123"
    c.phone = "02-1234-5678"
    c.email = "info@hankook-const.co.kr"
  },
  daehan: Company.find_or_create_by!(business_no: "234-56-78901") { |c|
    c.name = "(주)대한건축"
    c.company_type = :general_contractor
    c.ceo_name = "이대한"
    c.address = "서울특별시 서초구 서초대로 456"
    c.phone = "02-2345-6789"
    c.email = "info@daehan-arch.co.kr"
  },
  seoul_rebar: Company.find_or_create_by!(business_no: "345-67-89012") { |c|
    c.name = "(주)서울철근"
    c.company_type = :subcontractor
    c.ceo_name = "박철근"
    c.address = "경기도 성남시 분당구 정자로 78"
    c.phone = "031-345-6789"
    c.email = "info@seoul-rebar.co.kr"
  },
  hyundai_elec: Company.find_or_create_by!(business_no: "456-78-90123") { |c|
    c.name = "(주)현대전기"
    c.company_type = :subcontractor
    c.ceo_name = "최전기"
    c.address = "경기도 수원시 영통구 광교로 90"
    c.phone = "031-456-7890"
    c.email = "info@hyundai-elec.co.kr"
  },
  gangnam_dev: Company.find_or_create_by!(business_no: "567-89-01234") { |c|
    c.name = "(주)강남개발"
    c.company_type = :client
    c.ceo_name = "정강남"
    c.address = "서울특별시 강남구 압구정로 200"
    c.phone = "02-5678-9012"
    c.email = "info@gangnam-dev.co.kr"
  },
  mirae_mat: Company.find_or_create_by!(business_no: "678-90-12345") { |c|
    c.name = "(주)미래자재"
    c.company_type = :supplier
    c.ceo_name = "한미래"
    c.address = "인천광역시 남동구 공단대로 300"
    c.phone = "032-678-9012"
    c.email = "info@mirae-mat.co.kr"
  }
}
puts "  Companies: #{Company.count}"

# ============================================================
# 2. 사용자 데이터
# ============================================================
default_password = "password123"

users = {
  admin: User.find_or_create_by!(email_address: "admin@tooktak.kr") { |u|
    u.company = companies[:hankook]
    u.name = "관리자"
    u.phone = "010-0000-0001"
    u.role = :admin
    u.status = :active
    u.position = "시스템관리자"
    u.department = "IT"
    u.password = default_password
  },
  kim_manager: User.find_or_create_by!(email_address: "kim.manager@tooktak.kr") { |u|
    u.company = companies[:hankook]
    u.name = "김현장"
    u.phone = "010-1111-1001"
    u.role = :manager
    u.status = :active
    u.position = "현장소장"
    u.department = "공사팀"
    u.password = default_password
  },
  lee_super: User.find_or_create_by!(email_address: "lee.super@tooktak.kr") { |u|
    u.company = companies[:hankook]
    u.name = "이감리"
    u.phone = "010-1111-1002"
    u.role = :supervisor
    u.status = :active
    u.position = "감리"
    u.department = "품질팀"
    u.password = default_password
  },
  park_manager: User.find_or_create_by!(email_address: "park.manager@tooktak.kr") { |u|
    u.company = companies[:daehan]
    u.name = "박소장"
    u.phone = "010-2222-2001"
    u.role = :manager
    u.status = :active
    u.position = "현장소장"
    u.department = "공사팀"
    u.password = default_password
  },
  choi_work: User.find_or_create_by!(email_address: "choi.work@tooktak.kr") { |u|
    u.company = companies[:seoul_rebar]
    u.name = "최작업"
    u.phone = "010-3333-3001"
    u.role = :worker
    u.status = :active
    u.position = "철근공"
    u.password = default_password
  },
  jung_elec: User.find_or_create_by!(email_address: "jung.elec@tooktak.kr") { |u|
    u.company = companies[:hyundai_elec]
    u.name = "정전기"
    u.phone = "010-4444-4001"
    u.role = :worker
    u.status = :active
    u.position = "전기기사"
    u.password = default_password
  },
  han_client: User.find_or_create_by!(email_address: "han.client@tooktak.kr") { |u|
    u.company = companies[:gangnam_dev]
    u.name = "한발주"
    u.phone = "010-5555-5001"
    u.role = :client
    u.status = :active
    u.position = "담당이사"
    u.department = "개발본부"
    u.password = default_password
  }
}
puts "  Users: #{User.count}"

# ============================================================
# 3. 공정 카테고리
# ============================================================
root_categories = {
  a: WorkCategory.find_or_create_by!(code: "A") { |c| c.name = "토공사"; c.sort_order = 1 },
  b: WorkCategory.find_or_create_by!(code: "B") { |c| c.name = "콘크리트공사"; c.sort_order = 2 },
  c: WorkCategory.find_or_create_by!(code: "C") { |c| c.name = "철근공사"; c.sort_order = 3 },
  d: WorkCategory.find_or_create_by!(code: "D") { |c| c.name = "거푸집공사"; c.sort_order = 4 },
  e: WorkCategory.find_or_create_by!(code: "E") { |c| c.name = "조적공사"; c.sort_order = 5 },
  f: WorkCategory.find_or_create_by!(code: "F") { |c| c.name = "방수공사"; c.sort_order = 6 },
  g: WorkCategory.find_or_create_by!(code: "G") { |c| c.name = "마감공사"; c.sort_order = 7 },
  h: WorkCategory.find_or_create_by!(code: "H") { |c| c.name = "전기공사"; c.sort_order = 8 },
  i: WorkCategory.find_or_create_by!(code: "I") { |c| c.name = "기계설비공사"; c.sort_order = 9 },
  j: WorkCategory.find_or_create_by!(code: "J") { |c| c.name = "소방공사"; c.sort_order = 10 }
}

sub_categories = {
  b01: WorkCategory.find_or_create_by!(code: "B01") { |c| c.name = "기초콘크리트"; c.parent = root_categories[:b]; c.sort_order = 1 },
  b02: WorkCategory.find_or_create_by!(code: "B02") { |c| c.name = "골조콘크리트"; c.parent = root_categories[:b]; c.sort_order = 2 },
  b03: WorkCategory.find_or_create_by!(code: "B03") { |c| c.name = "슬래브콘크리트"; c.parent = root_categories[:b]; c.sort_order = 3 },
  h01: WorkCategory.find_or_create_by!(code: "H01") { |c| c.name = "수변전설비"; c.parent = root_categories[:h]; c.sort_order = 1 },
  h02: WorkCategory.find_or_create_by!(code: "H02") { |c| c.name = "동력설비"; c.parent = root_categories[:h]; c.sort_order = 2 },
  h03: WorkCategory.find_or_create_by!(code: "H03") { |c| c.name = "조명설비"; c.parent = root_categories[:h]; c.sort_order = 3 }
}
puts "  Work Categories: #{WorkCategory.count}"

# ============================================================
# 4. 프로젝트
# ============================================================
projects = {
  gangnam: Project.find_or_create_by!(project_no: "PRJ-2024-001") { |p|
    p.name = "강남 복합주거시설 신축공사"
    p.client_company = companies[:gangnam_dev]
    p.contractor = companies[:hankook]
    p.project_type = :new_construction
    p.status = :in_progress
    p.address = "서울특별시 강남구 역삼동 123-45"
    p.latitude = 37.5013
    p.longitude = 127.0392
    p.site_area = 3500.00
    p.building_area = 1800.00
    p.total_floor_area = 25000.00
    p.floors_above = 25
    p.floors_below = 3
    p.contract_date = "2024-01-15"
    p.start_date = "2024-03-01"
    p.planned_end_date = "2026-02-28"
    p.contract_amount = 85_000_000_000
    p.budget_amount = 83_000_000_000
    p.progress_rate = 35.50
    p.manager = users[:kim_manager]
    p.created_by = users[:admin]
  },
  seocho: Project.find_or_create_by!(project_no: "PRJ-2024-002") { |p|
    p.name = "서초 오피스텔 리모델링공사"
    p.client_company = companies[:gangnam_dev]
    p.contractor = companies[:daehan]
    p.project_type = :renovation
    p.status = :in_progress
    p.address = "서울특별시 서초구 서초동 789-12"
    p.latitude = 37.4837
    p.longitude = 127.0324
    p.site_area = 1200.00
    p.building_area = 800.00
    p.total_floor_area = 9600.00
    p.floors_above = 12
    p.floors_below = 2
    p.contract_date = "2024-04-01"
    p.start_date = "2024-05-01"
    p.planned_end_date = "2025-04-30"
    p.contract_amount = 12_000_000_000
    p.budget_amount = 11_500_000_000
    p.progress_rate = 62.30
    p.manager = users[:park_manager]
    p.created_by = users[:admin]
  },
  pangyo: Project.find_or_create_by!(project_no: "PRJ-2023-015") { |p|
    p.name = "판교 물류센터 신축공사"
    p.client_company = companies[:gangnam_dev]
    p.contractor = companies[:hankook]
    p.project_type = :new_construction
    p.status = :completed
    p.address = "경기도 성남시 분당구 판교동 456-78"
    p.latitude = 37.3943
    p.longitude = 127.1110
    p.site_area = 8000.00
    p.building_area = 5000.00
    p.total_floor_area = 40000.00
    p.floors_above = 4
    p.floors_below = 1
    p.contract_date = "2023-01-10"
    p.start_date = "2023-03-01"
    p.planned_end_date = "2024-02-29"
    p.contract_amount = 45_000_000_000
    p.budget_amount = 44_000_000_000
    p.progress_rate = 100.00
    p.manager = users[:kim_manager]
    p.created_by = users[:admin]
  }
}
puts "  Projects: #{Project.count}"

# ============================================================
# 5. 프로젝트 멤버
# ============================================================
[
  [projects[:gangnam], users[:kim_manager], :manager],
  [projects[:gangnam], users[:lee_super], :supervisor],
  [projects[:gangnam], users[:choi_work], :worker],
  [projects[:gangnam], users[:han_client], :client],
  [projects[:seocho], users[:park_manager], :manager],
  [projects[:seocho], users[:jung_elec], :worker]
].each do |project, user, role|
  ProjectMember.find_or_create_by!(project: project, user: user) { |pm| pm.role = role }
end
puts "  Project Members: #{ProjectMember.count}"

# ============================================================
# 6. 하도급 계약
# ============================================================
subcontracts = {
  rebar: Subcontract.find_or_create_by!(project: projects[:gangnam], subcontractor: companies[:seoul_rebar], contract_no: "SUB-2024-001-01") { |s|
    s.work_scope = "철근콘크리트 골조공사 전체"
    s.contract_amount = 18_000_000_000
    s.start_date = "2024-03-01"
    s.end_date = "2025-08-31"
    s.status = :in_progress
  },
  elec: Subcontract.find_or_create_by!(project: projects[:gangnam], subcontractor: companies[:hyundai_elec], contract_no: "SUB-2024-001-02") { |s|
    s.work_scope = "전기설비 전체공사"
    s.contract_amount = 5_500_000_000
    s.start_date = "2024-06-01"
    s.end_date = "2025-12-31"
    s.status = :in_progress
  }
}
puts "  Subcontracts: #{Subcontract.count}"

# ============================================================
# 7. 작업지시서
# ============================================================
work_orders = {
  wo1: WorkOrder.find_or_create_by!(order_no: "WO-2025-001-001") { |w|
    w.project = projects[:gangnam]
    w.category = sub_categories[:b02]
    w.title = "5층 골조 콘크리트 타설"
    w.description = "5층 전체 골조 콘크리트 타설 작업. 배합비 24-21-12 기준으로 시행."
    w.location = "5층 전체"
    w.floor = "5F"
    w.status = :in_progress
    w.priority = :high
    w.planned_start = "2025-03-10"
    w.planned_end = "2025-03-15"
    w.assigned_to = users[:choi_work]
    w.created_by = users[:kim_manager]
  },
  wo2: WorkOrder.find_or_create_by!(order_no: "WO-2025-001-002") { |w|
    w.project = projects[:gangnam]
    w.category = root_categories[:c]
    w.title = "5층 철근 배근 작업"
    w.description = "5층 기둥 및 보 철근 배근. D25@200 기준."
    w.location = "5층 기둥·보"
    w.floor = "5F"
    w.status = :completed
    w.priority = :high
    w.planned_start = "2025-03-05"
    w.planned_end = "2025-03-09"
    w.assigned_to = users[:choi_work]
    w.created_by = users[:kim_manager]
  },
  wo3: WorkOrder.find_or_create_by!(order_no: "WO-2025-001-003") { |w|
    w.project = projects[:gangnam]
    w.category = sub_categories[:h02]
    w.title = "3~5층 전기 간선 포설"
    w.description = "3층부터 5층까지 주요 전기 간선 케이블 포설 및 트레이 설치."
    w.location = "3~5층 EPS실"
    w.floor = "3F~5F"
    w.status = :pending
    w.priority = :medium
    w.planned_start = "2025-03-20"
    w.planned_end = "2025-04-05"
    w.assigned_to = users[:jung_elec]
    w.created_by = users[:park_manager]
  },
  wo4: WorkOrder.find_or_create_by!(order_no: "WO-2024-002-001") { |w|
    w.project = projects[:seocho]
    w.category = root_categories[:g]
    w.title = "3~6층 도배 및 바닥재 시공"
    w.description = "리모델링 구간 도배 재시공 및 LVT 바닥재 설치."
    w.location = "3~6층 전체 세대"
    w.floor = "3F~6F"
    w.status = :in_progress
    w.priority = :medium
    w.planned_start = "2025-02-15"
    w.planned_end = "2025-04-30"
    w.assigned_to = users[:park_manager]
    w.created_by = users[:park_manager]
  }
}
puts "  Work Orders: #{WorkOrder.count}"

# ============================================================
# 8. 자재
# ============================================================
materials = {
  concrete: Material.find_or_create_by!(code: "MAT-CON-001") { |m|
    m.name = "레미콘 25-21-12"
    m.category = "콘크리트"
    m.specification = "25-21-12 / 슬럼프 120"
    m.unit = "m³"
    m.unit_price = 80_000
    m.supplier = companies[:mirae_mat]
  },
  rebar_d25: Material.find_or_create_by!(code: "MAT-STL-001") { |m|
    m.name = "철근 D25"
    m.category = "철근"
    m.specification = "SD400 D25 12m"
    m.unit = "ton"
    m.unit_price = 1_100_000
    m.supplier = companies[:mirae_mat]
  },
  rebar_d16: Material.find_or_create_by!(code: "MAT-STL-002") { |m|
    m.name = "철근 D16"
    m.category = "철근"
    m.specification = "SD400 D16 12m"
    m.unit = "ton"
    m.unit_price = 1_050_000
    m.supplier = companies[:mirae_mat]
  },
  cable: Material.find_or_create_by!(code: "MAT-ELC-001") { |m|
    m.name = "CV 케이블 240"
    m.category = "전선"
    m.specification = "CV 240mm² 1C"
    m.unit = "m"
    m.unit_price = 8_500
    m.supplier = companies[:mirae_mat]
  },
  lvt: Material.find_or_create_by!(code: "MAT-FIN-001") { |m|
    m.name = "LVT 바닥재"
    m.category = "마감재"
    m.specification = "두께 3mm 600×600"
    m.unit = "m²"
    m.unit_price = 15_000
    m.supplier = companies[:mirae_mat]
  }
}
puts "  Materials: #{Material.count}"

# ============================================================
# 9. 자재 발주
# ============================================================
MaterialOrder.find_or_create_by!(order_no: "MO-2025-001-001") { |mo|
  mo.project = projects[:gangnam]
  mo.material = materials[:concrete]
  mo.supplier = companies[:mirae_mat]
  mo.status = :delivered
  mo.planned_qty = 450.00
  mo.ordered_qty = 450.00
  mo.delivered_qty = 450.00
  mo.used_qty = 380.00
  mo.unit_price = 80_000
  mo.total_amount = 36_000_000
  mo.planned_date = "2025-03-08"
  mo.order_date = "2025-03-06"
  mo.delivery_date = "2025-03-10"
  mo.work_order = work_orders[:wo1]
  mo.created_by = users[:kim_manager]
}
MaterialOrder.find_or_create_by!(order_no: "MO-2025-001-002") { |mo|
  mo.project = projects[:gangnam]
  mo.material = materials[:rebar_d25]
  mo.supplier = companies[:mirae_mat]
  mo.status = :delivered
  mo.planned_qty = 85.00
  mo.ordered_qty = 85.00
  mo.delivered_qty = 85.00
  mo.used_qty = 85.00
  mo.unit_price = 1_100_000
  mo.total_amount = 93_500_000
  mo.planned_date = "2025-03-03"
  mo.order_date = "2025-03-01"
  mo.delivery_date = "2025-03-05"
  mo.work_order = work_orders[:wo2]
  mo.created_by = users[:kim_manager]
}
MaterialOrder.find_or_create_by!(order_no: "MO-2025-001-003") { |mo|
  mo.project = projects[:gangnam]
  mo.material = materials[:cable]
  mo.supplier = companies[:mirae_mat]
  mo.status = :ordered
  mo.planned_qty = 1200.00
  mo.ordered_qty = 1200.00
  mo.delivered_qty = 0.00
  mo.used_qty = 0.00
  mo.unit_price = 8_500
  mo.total_amount = 10_200_000
  mo.planned_date = "2025-03-18"
  mo.order_date = "2025-03-15"
  mo.work_order = work_orders[:wo3]
  mo.created_by = users[:park_manager]
}
puts "  Material Orders: #{MaterialOrder.count}"

# ============================================================
# 10. 검사 템플릿
# ============================================================
templates = {
  concrete_check: InspectionTemplate.find_or_create_by!(name: "콘크리트 타설 전 검사") { |t|
    t.category = sub_categories[:b02]
  },
  rebar_check: InspectionTemplate.find_or_create_by!(name: "철근 배근 검사") { |t|
    t.category = root_categories[:c]
  },
  elec_check: InspectionTemplate.find_or_create_by!(name: "전기설비 중간검사") { |t|
    t.category = root_categories[:h]
  }
}

{
  templates[:concrete_check] => [
    ["거푸집 설치 상태 확인", "뒤틀림·처짐 없을 것, 이음부 밀실"],
    ["철근 배근 상태 확인", "간격·피복두께 설계도서 기준"],
    ["청소 및 이물질 제거", "거푸집 내부 이물질 없을 것"],
    ["레미콘 배합 확인", "배합비 설계기준 일치"]
  ],
  templates[:rebar_check] => [
    ["철근 규격 확인", "SD400, 지름 설계도서 기준"],
    ["피복두께 확인", "기둥: 40mm 이상, 보: 40mm 이상"],
    ["이음 및 정착 확인", "이음길이 40d 이상"],
    ["결속 상태 확인", "결속선 모든 교차부 결속"]
  ],
  templates[:elec_check] => [
    ["배관 설치 상태", "CD관·EMT관 구분 시공, 굴곡반경 준수"],
    ["절연저항 측정", "500V DC, 1MΩ 이상"],
    ["접지 연속성 확인", "접지선 단선 없을 것"]
  ]
}.each do |template, items|
  items.each_with_index do |(item, criteria), idx|
    InspectionTemplateItem.find_or_create_by!(template: template, item: item) { |ti|
      ti.sort_order = idx + 1
      ti.criteria = criteria
    }
  end
end
puts "  Inspection Templates: #{InspectionTemplate.count} (#{InspectionTemplateItem.count} items)"

# ============================================================
# 11. 검사 기록
# ============================================================
Inspection.find_or_create_by!(project: projects[:gangnam], title: "5층 철근 배근 검사") { |i|
  i.work_order = work_orders[:wo2]
  i.template = templates[:rebar_check]
  i.inspection_type = :pre_work
  i.status = :passed
  i.location = "5층 전체"
  i.floor = "5F"
  i.scheduled_date = "2025-03-08"
  i.inspected_date = "2025-03-08"
  i.inspector = users[:lee_super]
  i.result_notes = "전체 검사 완료. 피복두께 일부 조정 후 합격 처리."
  i.created_by = users[:kim_manager]
}
Inspection.find_or_create_by!(project: projects[:gangnam], title: "5층 콘크리트 타설 전 검사") { |i|
  i.work_order = work_orders[:wo1]
  i.template = templates[:concrete_check]
  i.inspection_type = :in_progress
  i.status = :status_in_progress
  i.location = "5층 전체"
  i.floor = "5F"
  i.scheduled_date = "2025-03-10"
  i.inspector = users[:lee_super]
  i.created_by = users[:kim_manager]
}
puts "  Inspections: #{Inspection.count}"

# ============================================================
# 12. 이슈/하자
# ============================================================
issues = {
  iss1: Issue.find_or_create_by!(issue_no: "ISS-2025-001-001") { |i|
    i.project = projects[:gangnam]
    i.work_order = work_orders[:wo2]
    i.category = root_categories[:c]
    i.title = "5층 C-03 기둥 피복두께 부족"
    i.description = "5층 C-03 기둥 동측면 피복두께 28mm 측정 (기준: 40mm). 즉시 보강 조치 필요."
    i.location = "5층 C-03 기둥"
    i.floor = "5F"
    i.status = :in_progress
    i.severity = :major
    i.reported_by = users[:lee_super]
    i.assigned_to = users[:choi_work]
    i.due_date = "2025-03-09"
  },
  iss2: Issue.find_or_create_by!(issue_no: "ISS-2025-001-002") { |i|
    i.project = projects[:gangnam]
    i.work_order = work_orders[:wo1]
    i.category = root_categories[:b]
    i.title = "4층 슬래브 균열 발생"
    i.description = "4층 슬래브 중앙부 0.2mm 균열 확인. 비구조적 균열로 판단되나 모니터링 필요."
    i.location = "4층 슬래브"
    i.floor = "4F"
    i.status = :open
    i.severity = :minor
    i.reported_by = users[:kim_manager]
    i.assigned_to = users[:choi_work]
    i.due_date = "2025-03-30"
  },
  iss3: Issue.find_or_create_by!(issue_no: "ISS-2024-002-001") { |i|
    i.project = projects[:seocho]
    i.work_order = work_orders[:wo4]
    i.category = root_categories[:g]
    i.title = "5층 301호 바닥재 들뜸"
    i.description = "5층 301호 LVT 바닥재 시공 후 일부 구간 들뜸 현상 발생. 재시공 필요."
    i.location = "5층 301호"
    i.floor = "5F"
    i.status = :resolved
    i.severity = :minor
    i.reported_by = users[:park_manager]
    i.assigned_to = users[:park_manager]
    i.due_date = "2025-03-10"
  }
}
puts "  Issues: #{Issue.count}"

# ============================================================
# 13. 이슈 댓글
# ============================================================
IssueComment.find_or_create_by!(issue: issues[:iss1], author: users[:choi_work], content: "피복 스페이서 추가 설치 완료. 재측정 결과 42mm 확인. 감리 확인 요청드립니다.")
IssueComment.find_or_create_by!(issue: issues[:iss1], author: users[:lee_super], content: "재측정 확인 완료. 기준 충족 확인. 이슈 해결 처리 예정.")
IssueComment.find_or_create_by!(issue: issues[:iss3], author: users[:park_manager], content: "들뜸 구간 전체 제거 후 재시공 완료. 검토 부탁드립니다.")
puts "  Issue Comments: #{IssueComment.count}"

# ============================================================
# 14. 일보
# ============================================================
dr1 = DailyReport.find_or_create_by!(project: projects[:gangnam], report_date: "2025-03-10", created_by: users[:kim_manager]) { |dr|
  dr.weather = "맑음"
  dr.temperature = 8.5
  dr.work_summary = "5층 콘크리트 타설 작업 시작. 레미콘 450m³ 타설 완료 (전체의 84%)."
  dr.progress_notes = "5층 골조 공정률 84% 달성. 나머지 16%는 내일 완료 예정."
  dr.safety_notes = "타설 중 낙하물 방지망 점검 완료. 안전 이상 없음."
  dr.worker_count = 42
}
dr2 = DailyReport.find_or_create_by!(project: projects[:gangnam], report_date: "2025-03-09", created_by: users[:kim_manager]) { |dr|
  dr.weather = "흐림"
  dr.temperature = 6.0
  dr.work_summary = "5층 철근 배근 완료 및 감리 검사 합격. 거푸집 최종 점검 완료."
  dr.progress_notes = "5층 철근 배근 100% 완료. 감리 검사 합격 처리."
  dr.safety_notes = "비계 작업 시 안전대 착용 전원 확인. 위험 요소 없음."
  dr.worker_count = 38
}

DailyReportItem.find_or_create_by!(report: dr1, description: "5층 콘크리트 타설") { |di|
  di.work_order = work_orders[:wo1]; di.category = sub_categories[:b02]
  di.quantity = 380.00; di.unit = "m³"; di.worker_count = 30; di.progress_rate = 84.00
}
DailyReportItem.find_or_create_by!(report: dr1, description: "5층 거푸집 존치 관리") { |di|
  di.category = root_categories[:d]; di.worker_count = 12
}
DailyReportItem.find_or_create_by!(report: dr2, description: "5층 철근 배근") { |di|
  di.work_order = work_orders[:wo2]; di.category = root_categories[:c]
  di.quantity = 85.00; di.unit = "ton"; di.worker_count = 25; di.progress_rate = 100.00
}
DailyReportItem.find_or_create_by!(report: dr2, description: "5층 거푸집 점검") { |di|
  di.category = root_categories[:d]; di.worker_count = 13
}
puts "  Daily Reports: #{DailyReport.count} (#{DailyReportItem.count} items)"

# ============================================================
# 15. 공정표
# ============================================================
sched1 = Schedule.find_or_create_by!(project: projects[:gangnam], name: "강남복합주거 실시공정표 v3") { |s|
  s.version = 3; s.is_baseline = true; s.created_by = users[:kim_manager]
}
Schedule.find_or_create_by!(project: projects[:seocho], name: "서초오피스텔 공정표 v1") { |s|
  s.version = 1; s.is_baseline = true; s.created_by = users[:park_manager]
}

[
  { schedule: sched1, wbs_code: "1",   name: "골조공사",           level: 1, sort_order: 1, planned_start: "2024-03-01", planned_end: "2025-10-31", status: :in_progress,  progress_rate: 35.5, weight: 45.0 },
  { schedule: sched1, wbs_code: "1.1", name: "지하층 골조",        level: 2, sort_order: 2, planned_start: "2024-03-01", planned_end: "2024-08-31", status: :completed,    progress_rate: 100.0, weight: 15.0 },
  { schedule: sched1, wbs_code: "1.2", name: "지상층 골조 (1~10F)", level: 2, sort_order: 3, planned_start: "2024-09-01", planned_end: "2025-04-30", status: :in_progress, progress_rate: 50.0, weight: 20.0 },
  { schedule: sched1, wbs_code: "1.3", name: "지상층 골조 (11~25F)", level: 2, sort_order: 4, planned_start: "2025-05-01", planned_end: "2025-10-31", status: :not_started, progress_rate: 0.0, weight: 10.0 },
  { schedule: sched1, wbs_code: "2",   name: "마감공사",           level: 1, sort_order: 5, planned_start: "2025-06-01", planned_end: "2026-01-31", status: :not_started,  progress_rate: 0.0, weight: 35.0 },
  { schedule: sched1, wbs_code: "3",   name: "전기·기계설비",      level: 1, sort_order: 6, planned_start: "2024-09-01", planned_end: "2026-01-31", status: :in_progress,  progress_rate: 20.0, weight: 20.0 }
].each do |attrs|
  ScheduleItem.find_or_create_by!(schedule: attrs[:schedule], wbs_code: attrs[:wbs_code]) { |si|
    si.name = attrs[:name]; si.level = attrs[:level]; si.sort_order = attrs[:sort_order]
    si.planned_start = attrs[:planned_start]; si.planned_end = attrs[:planned_end]
    si.status = attrs[:status]; si.progress_rate = attrs[:progress_rate]; si.weight = attrs[:weight]
  }
end
puts "  Schedules: #{Schedule.count} (#{ScheduleItem.count} items)"

# ============================================================
# 16. 비용
# ============================================================
[
  { project: projects[:gangnam], category: :material, work_order: work_orders[:wo1], description: "레미콘 구매 (5층 타설용)", amount: 36_000_000, cost_date: "2025-03-10", payment_status: :paid, recorded_by: users[:kim_manager] },
  { project: projects[:gangnam], category: :material, work_order: work_orders[:wo2], description: "철근 D25 구매 (5층 배근용)", amount: 93_500_000, cost_date: "2025-03-05", payment_status: :paid, recorded_by: users[:kim_manager] },
  { project: projects[:gangnam], category: :labor, description: "3월 1주차 직영 노무비", amount: 28_000_000, cost_date: "2025-03-07", payment_status: :paid, recorded_by: users[:kim_manager] },
  { project: projects[:gangnam], category: :subcontract, description: "(주)서울철근 2월 기성금", amount: 850_000_000, cost_date: "2025-03-05", payment_status: :paid, recorded_by: users[:kim_manager] },
  { project: projects[:seocho], category: :material, work_order: work_orders[:wo4], description: "LVT 바닥재 구매", amount: 12_000_000, cost_date: "2025-02-20", payment_status: :paid, recorded_by: users[:park_manager] }
].each do |attrs|
  Cost.find_or_create_by!(project: attrs[:project], description: attrs[:description]) { |c|
    c.category = attrs[:category]
    c.work_order = attrs[:work_order]
    c.amount = attrs[:amount]
    c.cost_date = attrs[:cost_date]
    c.payment_status = attrs[:payment_status]
    c.recorded_by = attrs[:recorded_by]
  }
end
puts "  Costs: #{Cost.count}"

# ============================================================
# 17. 기성 청구
# ============================================================
Billing.find_or_create_by!(billing_no: "BIL-2025-001-02") { |b|
  b.project = projects[:gangnam]; b.billing_month = "2025-02-01"
  b.progress_rate = 32.50; b.claim_amount = 27_625_000_000; b.approved_amount = 27_200_000_000
  b.payment_status = :paid; b.submitted_at = "2025-03-05"; b.approved_at = "2025-03-10"
}
Billing.find_or_create_by!(billing_no: "BIL-2025-001-03") { |b|
  b.project = projects[:gangnam]; b.billing_month = "2025-03-01"
  b.progress_rate = 35.50; b.claim_amount = 2_550_000_000
  b.payment_status = :pending; b.submitted_at = "2025-04-03"
}
Billing.find_or_create_by!(billing_no: "BIL-2025-002-02") { |b|
  b.project = projects[:seocho]; b.billing_month = "2025-02-01"
  b.progress_rate = 58.00; b.claim_amount = 6_960_000_000; b.approved_amount = 6_900_000_000
  b.payment_status = :paid; b.submitted_at = "2025-03-05"; b.approved_at = "2025-03-12"
}
puts "  Billings: #{Billing.count}"

# ============================================================
# 18. 근로자
# ============================================================
workers = {
  hong: Worker.find_or_create_by!(name: "홍길동", company: companies[:seoul_rebar]) { |w|
    w.phone = "010-9001-0001"; w.trade = "철근공"; w.skill_level = "특급"
  },
  kim_cs: Worker.find_or_create_by!(name: "김철수", company: companies[:seoul_rebar]) { |w|
    w.phone = "010-9001-0002"; w.trade = "철근공"; w.skill_level = "고급"
  },
  lee_yh: Worker.find_or_create_by!(name: "이영희", company: companies[:seoul_rebar]) { |w|
    w.phone = "010-9001-0003"; w.trade = "목수"; w.skill_level = "고급"
  },
  park_e: Worker.find_or_create_by!(name: "박전기", company: companies[:hyundai_elec]) { |w|
    w.phone = "010-9002-0001"; w.trade = "전기공"; w.skill_level = "특급"
  },
  choi_s: Worker.find_or_create_by!(name: "최안전", company: companies[:hankook]) { |w|
    w.phone = "010-9003-0001"; w.trade = "안전원"; w.skill_level = "고급"
  }
}
puts "  Workers: #{Worker.count}"

# ============================================================
# 19. 출역 기록
# ============================================================
[
  { project: projects[:gangnam], worker: workers[:hong],  work_date: "2025-03-10", check_in: "2025-03-10 07:30", check_out: "2025-03-10 18:00", work_hours: 9.5, daily_wage: 350_000, work_type: "정규" },
  { project: projects[:gangnam], worker: workers[:kim_cs], work_date: "2025-03-10", check_in: "2025-03-10 07:30", check_out: "2025-03-10 18:00", work_hours: 9.5, daily_wage: 300_000, work_type: "정규" },
  { project: projects[:gangnam], worker: workers[:lee_yh], work_date: "2025-03-10", check_in: "2025-03-10 07:30", check_out: "2025-03-10 18:00", work_hours: 9.5, daily_wage: 280_000, work_type: "정규" },
  { project: projects[:gangnam], worker: workers[:park_e], work_date: "2025-03-10", check_in: "2025-03-10 08:00", check_out: "2025-03-10 18:30", work_hours: 9.5, daily_wage: 320_000, work_type: "정규" },
  { project: projects[:gangnam], worker: workers[:hong],  work_date: "2025-03-09", check_in: "2025-03-09 07:30", check_out: "2025-03-09 17:30", work_hours: 9.0, daily_wage: 350_000, work_type: "정규" }
].each do |attrs|
  Attendance.find_or_create_by!(project: attrs[:project], worker: attrs[:worker], work_date: attrs[:work_date]) { |a|
    a.check_in = attrs[:check_in]; a.check_out = attrs[:check_out]
    a.work_hours = attrs[:work_hours]; a.daily_wage = attrs[:daily_wage]
    a.work_type = attrs[:work_type]; a.recorded_by = users[:kim_manager]
  }
end
puts "  Attendances: #{Attendance.count}"

# ============================================================
# 20. 안전점검
# ============================================================
sc = SafetyCheck.find_or_create_by!(project: projects[:gangnam], check_date: "2025-03-10") { |s|
  s.checker = users[:lee_super]
  s.overall_result = "양호"
  s.notes = "전반적으로 안전 상태 양호. 5층 작업 구간 낙하물 방지망 상태 확인 요망."
}

[
  ["개인보호구", "안전모 착용", "양호", "전원 착용 확인"],
  ["개인보호구", "안전대 착용 (고소작업)", "양호", "2m 이상 작업자 전원 착용"],
  ["가설시설", "비계 안전상태", "양호", "결속 상태 이상 없음"],
  ["가설시설", "낙하물 방지망", "주의", "5층 동측 일부 고정 보강 필요"],
  ["작업환경", "정리정돈", "양호", "자재 적치 구역 준수"]
].each do |category, item, result, notes|
  SafetyCheckItem.find_or_create_by!(safety_check: sc, item: item) { |si|
    si.category = category; si.result = result; si.notes = notes
  }
end
puts "  Safety Checks: #{SafetyCheck.count} (#{SafetyCheckItem.count} items)"

# ============================================================
# 21. 알림
# ============================================================
Notification.find_or_create_by!(user: users[:choi_work], title: "작업지시서 배정") { |n|
  n.project = projects[:gangnam]; n.notification_type = :approval_request
  n.body = "WO-2025-001-001 작업지시서가 배정되었습니다."
  n.link_type = "work_order"; n.link_id = work_orders[:wo1].id; n.is_read = true
}
Notification.find_or_create_by!(user: users[:choi_work], title: "이슈 배정") { |n|
  n.project = projects[:gangnam]; n.notification_type = :alert
  n.body = "ISS-2025-001-001 이슈가 귀하에게 배정되었습니다."
  n.link_type = "issue"; n.link_id = issues[:iss1].id; n.is_read = true
}
Notification.find_or_create_by!(user: users[:kim_manager], title: "이슈 상태 변경") { |n|
  n.project = projects[:gangnam]; n.notification_type = :status_change
  n.body = "ISS-2025-001-001 이슈가 진행중으로 변경되었습니다."
  n.link_type = "issue"; n.link_id = issues[:iss1].id; n.is_read = false
}
Notification.find_or_create_by!(user: users[:lee_super], title: "검사 요청") { |n|
  n.project = projects[:gangnam]; n.notification_type = :approval_request
  n.body = "5층 콘크리트 타설 전 검사 일정이 등록되었습니다."
  n.link_type = "inspection"; n.is_read = false
}
puts "  Notifications: #{Notification.count}"

# ============================================================
# 22. 문서
# ============================================================
Document.find_or_create_by!(project: projects[:gangnam], title: "구조도면 S-101 ~ S-150") { |d|
  d.doc_type = :blueprint; d.description = "지상 5층 골조 구조도면"
  d.file_name = "structure_5F.pdf"; d.file_size = 8_547_200
  d.mime_type = "application/pdf"; d.uploaded_by = users[:kim_manager]
}
Document.find_or_create_by!(project: projects[:gangnam], title: "5층 콘크리트 타설 사진") { |d|
  d.doc_type = :photo; d.description = "2025-03-10 5층 타설 현장 사진"
  d.file_name = "concrete_5F_20250310.jpg"; d.file_size = 3_245_100
  d.mime_type = "image/jpeg"; d.uploaded_by = users[:kim_manager]
  d.work_order = work_orders[:wo1]
}
puts "  Documents: #{Document.count}"

puts "\n✓ Seed completed!"
puts "  Total: #{Company.count} companies, #{User.count} users, #{Project.count} projects"
puts "  #{WorkOrder.count} work orders, #{Issue.count} issues, #{Inspection.count} inspections"
