# frozen_string_literal: true

# 한국어 enum 번역 지원
# 사용법: model.status_i18n  →  "진행중"
module KoreanEnum
  extend ActiveSupport::Concern

  TRANSLATIONS = {
    # User roles
    "admin" => "관리자", "manager" => "현장소장", "supervisor" => "감리",
    "worker" => "작업자", "client" => "발주처",
    # User status
    "active" => "활성", "inactive" => "비활성", "pending" => "대기", "suspended" => "정지",
    # Company types
    "general_contractor" => "원도급", "subcontractor" => "하도급",
    "supplier" => "자재업체", "consultant" => "컨설턴트",
    # Project types
    "new_construction" => "신축", "renovation" => "리모델링", "repair" => "보수",
    "interior" => "인테리어", "civil" => "토목", "mechanical" => "기계",
    "electrical" => "전기", "plumbing" => "배관",
    # Project status
    "planning" => "계획", "bidding" => "입찰", "contracted" => "계약",
    "in_progress" => "진행중", "on_hold" => "보류", "completed" => "완료", "cancelled" => "취소",
    # Work order status
    "draft" => "초안", "approved" => "승인", "rejected" => "반려",
    # Work order priority
    "low" => "낮음", "medium" => "보통", "high" => "높음", "urgent" => "긴급",
    # Inspection type
    "pre_work" => "사전검사", "final" => "최종검사",
    "safety" => "안전검사", "quality" => "품질검사", "defect" => "하자검사",
    # Inspection status
    "scheduled" => "예정", "status_in_progress" => "검사중",
    "passed" => "합격", "failed" => "불합격", "conditionally_passed" => "조건부합격",
    # Issue status
    "open" => "등록", "resolved" => "해결", "closed" => "종료",
    # Issue severity
    "critical" => "심각", "major" => "중대", "minor" => "경미", "trivial" => "미미",
    # Schedule status
    "not_started" => "미착수", "delayed" => "지연",
    # Material status
    "planned" => "계획", "ordered" => "발주", "delivered" => "납품",
    "in_use" => "사용중", "consumed" => "소진", "returned" => "반품", "wasted" => "폐기",
    # Cost category
    "labor" => "노무비", "material" => "자재비", "equipment" => "장비비",
    "subcontract" => "하도급비", "overhead" => "경비",
    # Payment status
    "partial" => "부분납", "paid" => "완납", "overdue" => "연체",
    # Document type
    "blueprint" => "도면", "specification" => "시방서", "contract" => "계약서",
    "permit" => "인허가", "report" => "보고서", "photo" => "사진", "video" => "영상",
    # Notification type
    "info" => "정보", "warning" => "주의", "alert" => "알림",
    "approval_request" => "승인요청", "status_change" => "상태변경",
    # General
    "other" => "기타"
  }.freeze

  class_methods do
    def human_enum_name(value)
      TRANSLATIONS[value.to_s] || value.to_s.humanize
    end
  end

  # Dynamic _i18n methods for any enum
  def method_missing(method_name, *args, &block)
    if method_name.to_s.end_with?("_i18n")
      enum_name = method_name.to_s.chomp("_i18n")
      if self.class.defined_enums.key?(enum_name)
        value = send(enum_name)
        return TRANSLATIONS[value.to_s] || value.to_s.humanize
      end
    end
    super
  end

  def respond_to_missing?(method_name, include_private = false)
    if method_name.to_s.end_with?("_i18n")
      enum_name = method_name.to_s.chomp("_i18n")
      return true if self.class.defined_enums.key?(enum_name)
    end
    super
  end
end
