@module:backend.api
Feature: 留言发布、列表与删除接口

  @generated @layer:api @case:FP-002-001
  Scenario: 发布合法留言成功并写入数据库
    Given the test database is prepared
    When [agent] 发送解密后内容为"测试留言"的发布请求
    Then the response status should be 200
    And the database table "messages" should have 1 row where "content" = "测试留言"

  @generated @layer:api @case:FP-002-002
  Scenario: 发布后清理超过 1000 条的最旧记录
    Given the test database is prepared
    And the database table "messages" should have 1000 rows
    When [agent] 发布新留言
    Then the response status should be 200
    And the database table "messages" should have 0 rows where "content" = "最旧留言"

  @generated @layer:api @case:FP-002-003
  Scenario: 发布缺少密文字段返回参数错误
    Given the test environment is ready
    When [agent] 发送缺少密文字段的发布请求
    Then the response status should be 400
    And the response body should contain error code "MISSING_CIPHER"

  @generated @layer:api @case:FP-002-004
  Scenario: 数据库插入失败返回服务端错误
    Given the test environment is ready
    When [agent] 模拟数据库插入失败并发布留言
    Then the response status should be 500
    And the response body should contain error code "DB_ERROR"

  @generated @layer:api @case:FP-003-001
  Scenario: 列表接口返回加密响应与公开视图
    Given the test database is prepared
    And the database table "messages" should have 1 row
    When [agent] 请求留言列表
    Then the response status should be 200
    And the response body at "$.messages[0].id" should be "1"

  @generated @layer:api @case:FP-003-002
  Scenario: 删除已有留言成功
    Given the test database is prepared
    And the database table "messages" should have 1 row
    When [agent] 发送删除 id=1 的请求
    Then the response status should be 200
    And the database table "messages" should have 0 rows

  @generated @layer:api @case:FP-003-003
  Scenario: 删除不存在的留言返回 404
    Given the test database is prepared
    When [agent] 发送删除 id=999 的请求
    Then the response status should be 404
    And the response body should contain error code "NOT_FOUND"

  @generated @layer:api @case:FP-003-004
  Scenario: 删除缺少 id 返回参数错误
    Given the test environment is ready
    When [agent] 发送缺少 id 的删除请求
    Then the response status should be 400
    And the response body should contain error code "INVALID_ID"
