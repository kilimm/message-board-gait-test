@module:frontend.media
Feature: 图片选择、压缩与预览

  @generated @layer:ui @case:FP-006-001
  Scenario: 合法图片压缩并显示预览
    Given I am on the "留言板" page
    When [agent] 选择一张 800x600 的 JPEG 图片
    Then the element "图片预览" should be visible
    And [agent] 压缩后的最长边为 500px 且输出为 JPEG

  @generated @layer:ui @case:FP-006-002
  Scenario: 非图片文件被拒绝
    Given I am on the "留言板" page
    When [agent] 选择 text/plain 文件
    Then I should see the error "仅支持图片文件"

  @generated @layer:ui @case:FP-006-003
  Scenario: 超大图片被拒绝
    Given I am on the "留言板" page
    When [agent] 选择超过大小限制的图片
    Then I should see the error "图片大小超过限制"
