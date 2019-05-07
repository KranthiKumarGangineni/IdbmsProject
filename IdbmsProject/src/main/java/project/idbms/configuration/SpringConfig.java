package project.idbms.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

/**
 * Spring.xml/Servlet.xml is confgured as below..
 * 
 * @author Kranthi
 *
 */

@EnableWebMvc
@Configuration
// Scanning the Components
@ComponentScan(basePackages = "project.idbms")
public class SpringConfig extends WebMvcConfigurerAdapter {

	/**
	 * Used to resolve “internal resource view”
	 * 
	 * @return bean returns a jsp based on a predefined URL pattern
	 */
	@Bean
	public InternalResourceViewResolver viewResolver() {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setViewClass(JstlView.class);
		viewResolver.setPrefix("/WEB-INF/docs/");
		viewResolver.setSuffix(".jsp");
		return viewResolver;
	}

	// Spring does not know how to handle
	// content natively(could be a jsp), and to
	// this configuration is the way to tell it to delegate it to the
	// container.
	@Override
	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}

}
