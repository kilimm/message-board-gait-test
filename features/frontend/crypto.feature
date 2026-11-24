@module:frontend.crypto
Feature: 传输加密协议与口令派生

  @generated @layer:ui @case:FP-001-001
  Scenario: 当日口令派生密钥加密后可被服务端解密
    Given I am on the "/" page
    When [agent] 使用当日口令 PBKDF2 派生密钥并加密文本为 AES-CBC 包提交
    Then the response status should be 200
    And the response body at "$.content" should be "解密后的原文"

  @generated @layer:ui @case:FP-001-002
  Scenario: 跨日口令不一致时解密失败
    Given I am on the "/" page
    When [agent] 使用昨日口令派生密钥加密并提交
    Then the response status should be 400
    And the response body should contain error code "DECRYPT_FAILED"

  @generated @layer:ui @case:FP-001-003
  Scenario: 密文损坏时返回格式错误
    Given I am on the "/" page
    When [agent] 提交截断的密文包
    Then the response status should be 400
    And the response body should contain error code "INVALID_CIPHER"
