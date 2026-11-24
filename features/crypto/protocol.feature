@module:crypto.protocol
Feature: 加密传输协议与密文包一致性
  前后端使用同一口令派生密钥与同一密文包结构，任何一方参数偏移都必须被发现。

  @generated @layer:e2e @case:FP-001-001
  Scenario: 加密提交后响应可被同一口令解密
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"协议一致性测试"}
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.messages[0].text should be "协议一致性测试"

  @generated @layer:api @case:FP-001-002
  Scenario: 密文包结构不完整被拒绝
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with JSON:
      """
      {"enc":"invalid","iv":"invalid"}
      """
    Then the response status should be 400
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.total should be "0"

  @generated @layer:api @case:FP-001-003
  Scenario: 口令不一致导致解密失败
    Given the test environment is ready
    And the test database is prepared
    When [agent] 使用前一日口令派生的密文包提交留言到 "/api/messages"
    Then the response status should be 400
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.total should be "0"
