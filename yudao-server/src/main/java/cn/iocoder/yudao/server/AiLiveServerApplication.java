package cn.iocoder.yudao.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "cn.iocoder.yudao")
public class AiLiveServerApplication {
    public static void main(String[] args) { SpringApplication.run(AiLiveServerApplication.class, args); }
}
