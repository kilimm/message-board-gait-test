# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 创建与裁剪

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-001
  Scenario: 合法加密留言创建成功并出现在列表首位
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"测试留言"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.message.text should be "测试留言"
    When I send a GET request to "/api/messages?limit=1"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.list[0].text should be "测试留言"
    And the response body at $.ok should be "true"

  @generated @layer:api @case:MB-API-002
  Scenario: 非法密文包被拒绝且不写库
    When I send a POST request to "/api/messages" with JSON:
      """
      {"enc":"invalid-package"}
      """
    Then the response status should be 400
    When I send a GET request to "/api/messages?limit=1"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.list[0].text should be "测试留言"

  @generated @layer:api @case:MB-API-003
  Scenario: 空文本且无图片的留言被拒绝
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"   "}
      """
    Then the response status should be 400

  @generated @layer:api @case:MB-API-004
  Scenario: 超过一千条时裁剪为最新一千条
    Given the database table messages should have 1000 rows
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"最新留言"}
      """
    Then the response status should be 200
    Then the database table messages should have 1000 rows
    And the database table messages should have 0 rows where text = "最旧留言"
    When I send a GET request to "/api/messages?limit=1"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.list[0].text should be "最新留言"
