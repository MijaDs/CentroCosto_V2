package com.CentroCosto;

import com.CentroCosto.Repositories.CentroCostoRepo;
import com.CentroCosto.domain.centroCosto;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
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
