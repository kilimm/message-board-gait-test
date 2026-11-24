@module:frontend.app
Feature: 前端发布留言流程
  发布框文本计数、图片筛选压缩、加密提交与成功后置顶插入。

  @generated @layer:ui @case:FP-008-001
  Scenario: 填写文本后发布留言成功并置顶展示
    Given I am on the "/" page
    When I fill "留言" with "前端发布测试"
    And I click "发送"
    Then the page should contain "前端发布测试"
    And the element "留言" should be visible

  @generated @layer:ui @case:FP-008-002
  Scenario: 空内容提交给出提示且不新增留言
    Given I am on the "/" page
    When I fill "留言" with ""
    And I click "发送"
    Then I should see the error "请输入内容"
    And I should stay on the "/" page

  @generated @layer:ui @case:FP-008-003
  Scenario: 提交失败时提示错误并保留输入内容
    Given I am on the "/" page
    When I fill "留言" with "提交失败测试"
    And [agent] 在留言接口返回 500 的情况下点击发送
    Then I should see the error "发送失败"
    And I should stay on the "/" page
    And the page should contain "提交失败测试"

  @generated @layer:ui @case:FP-005-003
  Scenario: 选择超过 8MB 的图片被前端拦截
    Given I am on the "/" page
    When [agent] 选择一张大小为 9MB 的图片并触发上传预览
    Then I should see the error "图片大小不能超过8MB"
    And the element "留言" should be visible
