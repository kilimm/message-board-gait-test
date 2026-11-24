@module:backend.api
Feature: 留言发布、列表与删除接口

  @generated @layer:api @case:FP-002-001
  Scenario: 发布合法留言成功并写入数据库
    Given the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      { "text": "测试留言" }
      """
    Then the response status should be 200
    And the database table "messages" should have 1 row where "text" = "测试留言"

  @generated @layer:api @case:FP-002-002
  Scenario: 发布后清理超过 1000 条的最旧记录
    Given the test database is prepared
    And the database table "messages" should have 1000 rows
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      { "text": "新留言" }
      """
    Then the response status should be 200
    And the database table "messages" should have 0 rows where "text" = "最旧留言"

  @generated @layer:api @case:FP-002-003
  Scenario: 发布缺少密文字段返回参数错误
    Given the test environment is ready
    When I send a POST request to "/api/messages" with JSON:
      """
      { "text": "明文未加密" }
      """
    Then the response status should be 400
    And the response body at "$.ok" should be "false"

  @generated @layer:api @case:FP-002-004
  Scenario: 数据库插入失败返回服务端错误
    Given the test environment is ready
    When I send a POST request to "/api/messages" with JSON:
      """
      { "v": 2, "salt": "AAAA", "iv": "AAAA", "ct": "AAAA" }
      """
    Then the response status should be 401
    And the response body at "$.ok" should be "false"

  @generated @layer:api @case:FP-003-001
  Scenario: 列表接口返回加密响应与公开视图
    Given the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      { "text": "列表可见留言" }
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages"
    And I decrypt the response payload
    Then the response status should be 200
    And the response body at "$.list[0].text" should be "列表可见留言"

  @generated @layer:api @case:FP-003-002
  Scenario: 删除已有留言成功
    Given the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      { "text": "待删除留言" }
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages"
    And I decrypt the response payload
    And I store the response field "$.list[0].id" as "deleteId"
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      { "id": "{{var.deleteId}}" }
      """
    Then the response status should be 200
    And the database table "messages" should have 0 rows

  @generated @layer:api @case:FP-003-003
  Scenario: 删除不存在的留言返回 404
    Given the test database is prepared
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      { "id": "999" }
      """
    Then the response status should be 404
    And the response body at "$.ok" should be "false"

  @generated @layer:api @case:FP-003-004
  Scenario: 删除缺少 id 返回参数错误
    Given the test environment is ready
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      {}
      """
    Then the response status should be 400
    And the response body at "$.ok" should be "false"
