package com.aliyun.ams.push

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

internal class AliyunPushPluginTest {
  @Test
  fun onMethodCall_setPluginLogEnabled_completesResult() {
    val plugin = AliyunPushPlugin()
    val call = MethodCall("setPluginLogEnabled", mapOf("enabled" to true))
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(null)
  }

  @Test
  fun onMethodCall_messageReceiverReady_completesResult() {
    val plugin = AliyunPushPlugin()
    val call = MethodCall("messageReceiverReady", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(null)
  }

  @Test
  fun onMethodCall_createChannel_rejectsEmptyRequiredArguments() {
    val plugin = AliyunPushPlugin()
    val call = MethodCall("createChannel", mapOf("id" to "", "name" to "name"))
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(
      mapOf(
        "code" to "10001",
        "errorMsg" to "channel id and name can not be empty"
      )
    )
  }

  @Test
  fun onMethodCall_createChannelGroup_rejectsEmptyRequiredArguments() {
    val plugin = AliyunPushPlugin()
    val call = MethodCall("createChannelGroup", mapOf("id" to "id", "name" to ""))
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(
      mapOf(
        "code" to "10001",
        "errorMsg" to "channel group id and name can not be empty"
      )
    )
  }
}
