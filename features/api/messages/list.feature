# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 列表与条数限制

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-010
  Scenario: 空列表返回总数为零
    When I send a GET request to "/api/messages?limit=10"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.ok should be "true"
    When I send a GET request to "/api/stats"
    Then the response status should be 200
    And the response body at $.total should be "0"
    And the response body at $.max should be "1000"

  @generated @layer:api @case:MB-API-011
  Scenario: 按创建时间倒序返回最新留言
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"第一条"}
      """
    Then the response status should be 200
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"第二条"}
      """
    Then the response status should be 200
    Then the database table messages should have 1 row where text = "第一条"
    And the database table messages should have 1 row where text = "第二条"

  @generated @layer:api @case:MB-API-012
  Scenario: limit 参数限制返回条数但总数仍为全量
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言一"}
      """
    Then the response status should be 200
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言二"}
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=1"
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.list[0].text should be "留言二"
    When I send a GET request to "/api/messages?limit=200"
    Then the response status should be 200
    And I decrypt the response payload
    Then the database table messages should have 1 row where text = "留言一"
    And the database table messages should have 1 row where text = "留言二"
