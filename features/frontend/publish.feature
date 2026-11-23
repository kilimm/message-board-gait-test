@module:frontend.ui
Feature: 前端发布流程与快捷提交

  @generated @layer:ui @case:FP-007-001
  Scenario: 发布文本留言成功并置顶
    Given I am on the "留言板" page
    When [agent] 输入文本"测试留言"并点击发布按钮完成加密提交
    Then the response status should be 200
    And the page should contain "测试留言"
    And [agent] 新留言显示在列表顶部

  @generated @layer:ui @case:FP-007-002
  Scenario: 超过长度限制的文本被阻止提交
    Given I am on the "留言板" page
    When [agent] 输入超过长度限制的文本
    Then [agent] 阻止提交并提示字数超出限制

  @generated @layer:ui @case:FP-007-003
  Scenario: 发布接口失败时提示并恢复按钮
    Given I am on the "留言板" page
    When [agent] 提交后接口返回 500
    Then [agent] 显示发布失败提示且发布按钮恢复可用

  @generated @layer:ui @case:FP-007-004
  Scenario: 响应解密失败时提示且不插入留言
    Given I am on the "留言板" page
    When [agent] 提交成功但响应解密失败
    Then [agent] 显示解密失败提示且不插入留言
