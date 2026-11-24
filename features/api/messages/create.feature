# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 创建

  并发说明：api 层并发执行，断言必须按 text 作用域隔离，不能依赖全表行数或"最新一条"。

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-001
  Scenario: 合法加密留言创建成功并写入数据库
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-create-001"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.message.text should be "留言-create-001"
    Then the database table messages should have 1 row where text = "留言-create-001"

  @generated @layer:api @case:MB-API-002
  Scenario: 非法密文包被拒绝且不写库
    When I send a POST request to "/api/messages" with JSON:
      """
      {"enc":"invalid-package"}
      """
    Then the response status should be 400

  @generated @layer:api @case:MB-API-003
  Scenario: 空文本且无图片的留言被拒绝
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"   "}
      """
    Then the response status should be 400

  @generated @layer:api @case:MB-API-005
  Scenario: 文本超长被截断到 2000 字符以内
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"超长文本-trim-check"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.message.text should be "超长文本-trim-check"
