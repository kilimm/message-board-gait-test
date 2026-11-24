# generated-by: git-ai-test-flow
@module:web.publish @layer:ui
Feature: 留言板前端 - 发布留言

  Background:
    Given the test environment is ready
    And the test database is prepared
    And I am on the "/" page

  @generated @layer:ui @case:MB-UI-001
  Scenario: 填写文本后发布成功并展示在列表
    When I fill "#textInput" with "前端发布测试"
    And I click "#submitBtn"
    Then the page should contain "前端发布测试"

  @generated @layer:ui @case:MB-UI-002
  Scenario: 空内容提交给出提示
    When I click "#submitBtn"
    Then the page should contain "留言内容或图片不能为空"

  @generated @layer:ui @case:MB-UI-003
  Scenario: 页面展示留言板标题与空状态
    Then the page should contain "留言板"
    And the page should contain "最新留言"
