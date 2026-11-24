@module:api.messages
Feature: 留言创建与千条裁剪
  合法密文解密后写入数据库，并在同一事务内裁剪至最新 1000 条。

  @generated @layer:api @case:FP-002-001
  Scenario: 合法加密留言创建成功后出现在列表首位
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"测试留言"}
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.messages[0].text should be "测试留言"
    And the response body at $.total should be "1"

  @generated @layer:api @case:FP-002-002
  Scenario: 无效密文不写库
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with JSON:
      """
      {"enc":"invalid-package"}
      """
    Then the response status should be 400
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.total should be "0"

  @generated @layer:e2e @case:FP-002-003
  Scenario: 超过一千条时裁剪为最新一千条
    Given the test environment is ready
    And the test database is prepared
    When [agent] 在数据库中预置 1000 条历史留言
    And I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"最新留言"}
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.messages[0].text should be "最新留言"
    And the response body at $.total should be "1000"
