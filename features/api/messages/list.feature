@module:api.messages
Feature: 留言列表查询与排序
  列表按创建时间倒序返回最新留言，响应体加密，并给出全量总数统计。

  @generated @layer:api @case:FP-003-001
  Scenario: 空列表返回总数为零
    Given the test environment is ready
    And the test database is prepared
    When I send a GET request to "/api/messages?limit=10"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.total should be "0"
    And the response body at $.messages should be "[]"

  @generated @layer:api @case:FP-003-002
  Scenario: 按创建时间倒序返回最新留言
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"第一条"}
      """
    And I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"第二条"}
      """
    And I send a GET request to "/api/messages?limit=10"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.messages[0].text should be "第二条"
    And the response body at $.messages[1].text should be "第一条"
    And the response body at $.total should be "2"

  @generated @layer:api @case:FP-003-003
  Scenario: 条数参数限制返回条数但总数仍为全量
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言一"}
      """
    And I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言二"}
      """
    And I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言三"}
      """
    And I send a GET request to "/api/messages?limit=2"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.messages[0].text should be "留言三"
    And the response body at $.messages[1].text should be "留言二"
    And the response body at $.total should be "3"
