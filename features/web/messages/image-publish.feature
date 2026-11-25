@module:web.messages
Feature: 带图片留言的发布主流程

  @generated @layer:e2e @case:FP-006-004
  Scenario: 上传大图发布留言后列表展示该留言
    Given I am on the "/" page
    When [agent] 选择一张宽高为 900x900 的本地图片并填写留言内容为"图片发布-001"
    And I click "发布"
    Then the page should contain "图片发布-001"
    And the element "图片发布-001" should be visible
