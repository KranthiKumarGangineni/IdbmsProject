package project.idbms.configuration;

import javax.sql.DataSource;

import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@PropertySource("file:${mybatis.home}/db.properties")
// Scanning the Components
@ComponentScan(value = "project.idbms")
// Scanning Mapper Classes
@MapperScan("project.idbms.dao")
public class MybatisConfig {

	@Autowired
	private Environment environment;

	/**
	 * DataSource Creation
	 * 
	 * @throws Exception
	 */
	@Bean
	public DataSource getDataSourceDetails() {
		// Creating DataSource with the DB properties..
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(environment.getRequiredProperty("jdbc.driverClassName"));
		dataSource.setUrl(environment.getRequiredProperty("jdbc.url"));
		dataSource.setUsername(environment.getRequiredProperty("jdbc.username"));
		dataSource.setPassword(environment.getRequiredProperty("jdbc.password"));
		return dataSource;
	}

	/**
	 * Creates a SqlSessionFactoryBean used by the MyBatis mapper.
	 * 
	 * @return A SqlSessionFactoryBean object
	 * @throws Exception
	 *             on error
	 */
	@Bean
	public SqlSessionFactoryBean sqlSessionFactory() {
		SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setDataSource(getDataSourceDetails());
		return sessionFactory;
	}

	@Bean
	public PlatformTransactionManager platformTransactionManager() {
		return new DataSourceTransactionManager(getDataSourceDetails());
	}
}
