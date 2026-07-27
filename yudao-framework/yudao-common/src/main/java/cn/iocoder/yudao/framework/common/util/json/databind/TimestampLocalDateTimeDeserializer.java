package cn.iocoder.yudao.framework.common.util.json.databind;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * 基于时间戳的 LocalDateTime 反序列化器
 *
 * @author 老五
 */
public class TimestampLocalDateTimeDeserializer extends JsonDeserializer<LocalDateTime> {

    public static final TimestampLocalDateTimeDeserializer INSTANCE = new TimestampLocalDateTimeDeserializer();

    /**
     * 默认日期格式，兼容前端字符串传参
     */
    private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public LocalDateTime deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        // 数字类型：Long 时间戳 → LocalDateTime
        if (p.currentToken().isNumeric()) {
            return LocalDateTime.ofInstant(Instant.ofEpochMilli(p.getValueAsLong()), ZoneId.systemDefault());
        }
        // 字符串类型：兼容时间戳字符串（如 "1783872000000"）或日期字符串
        if (p.currentToken() == JsonToken.VALUE_STRING) {
            String text = p.getText().trim();
            if (text.isEmpty()) {
                return null;
            }
            try {
                // 先尝试作为纯数字时间戳解析
                long timestamp = Long.parseLong(text);
                return LocalDateTime.ofInstant(Instant.ofEpochMilli(timestamp), ZoneId.systemDefault());
            } catch (NumberFormatException ignored) {
                // 非纯数字，按日期字符串解析（如 "2026-07-13 00:00:00"）
                return LocalDateTime.parse(text, DEFAULT_FORMATTER);
            }
        }
        // 兜底：尝试 getValueAsLong（兼容其他可能性）
        return LocalDateTime.ofInstant(Instant.ofEpochMilli(p.getValueAsLong()), ZoneId.systemDefault());
    }

}
