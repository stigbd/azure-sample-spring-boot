package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.reactive.server.WebTestClient;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
class DemoApplicationTests {

	@Autowired
	private WebTestClient webClient;

	@Test
	void contextLoads() {
	}

	@Test
	void getPublic() throws Exception {
		webClient.get().uri("/public")
				.accept(MediaType.APPLICATION_JSON)
				.exchange()
				.expectStatus().isOk();
	}

	@Test
	void getUser() throws Exception {
		webClient.get().uri("/user")
				.accept(MediaType.APPLICATION_JSON)
				.exchange()
				.expectStatus().is3xxRedirection();
	}

	@Test
	void getAdmin() throws Exception {
		webClient.get().uri("/admin")
				.accept(MediaType.APPLICATION_JSON)
				.exchange()
				.expectStatus().is3xxRedirection();
	}
}
