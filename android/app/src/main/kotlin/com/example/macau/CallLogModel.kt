package com.example.macau

data class CallLogModel(
    val caller: String,
    val timeStamp: Long // store as epoch millis
)