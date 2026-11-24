@module:frontend.ui
Feature: 列表轮询、增量渲染与删除

  @generated @layer:ui @case:FP-008-001
  Scenario: 轮询增量渲染新留言
    Given I am on the "/" page
    When [agent] 等待 5 秒并收到包含新留言的列表
    Then the page should contain "新留言"
    And [agent] 仅新增未知 id 的留言而不重复渲染已知留言

  @generated @layer:ui @case:FP-008-002
  Scenario: 留言文本按纯文本转义渲染
    Given I am on the "/" page
    When [agent] 收到包含 HTML 标签的留言
    Then [agent] 页面以纯文本显示标签且不执行脚本

  @generated @layer:ui @case:FP-008-003
  Scenario: 删除留言成功后从列表移除
    Given I am on the "/" page
    When [agent] 点击删除按钮且删除接口成功
    Then the response status should be 200
    And [agent] 该留言从列表移除

  @generated @layer:ui @case:FP-008-004
  Scenario: 删除留言失败时保留并提示
    Given I am on the "/" page
    When [agent] 点击删除按钮但删除接口返回 500
    Then [agent] 显示删除失败提示并保留该留言
