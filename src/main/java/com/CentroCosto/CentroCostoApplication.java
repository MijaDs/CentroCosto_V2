package com.CentroCosto;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jdbc.repository.config.EnableJdbcRepositories;

@SpringBootApplication
@EnableJdbcRepositories
public class CentroCostoApplication {

	public static void main(String[] args) {
            
            SpringApplication.run(CentroCostoApplication.class, args);
            //try (ConfigurableApplicationContext ctxt = SpringApplication.run(CentroCostoApplication.class, args)) {
                //CentroCostoRepo bean =ctxt.getBean(CentroCostoRepo.class);
                
                //centroCosto entity = new centroCosto();
                //entity.setID_CENTROCOSTO(100);
                //entity.setNombre("Rectoria");
                //bean.save(entity);
           // }
	}

}
