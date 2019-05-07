package project.idbms.service;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import project.idbms.dao.MyBatisDAO;
import project.idbms.db.AllCourses;
import project.idbms.db.Department;
import project.idbms.db.StudentGrades;
import project.idbms.db.University;
import project.idbms.db.User;

@Service
public class MyBatisServiceImpl implements MyBatisService {

	@Autowired
	MyBatisDAO myBatisDao;

	private static final Logger logger = Logger.getLogger(MyBatisServiceImpl.class);

	@Override
	public List<University> fetchUnivDetails() {
		List<University> univList = null;
		try {
			univList = myBatisDao.fetchUnivDetails();
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching university details", dae);
		}
		return univList;
	}

	@Override
	public void registerUser(Integer userId, String encryptedPassword, String role, String username) {
		try {
			myBatisDao.registerUser(userId, encryptedPassword, role, username);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while inserting user details", dae);
		}
	}

	@Override
	public User fetchUserDetailsByUserId(Integer userId) {
		User user = null;
		try {
			user = myBatisDao.fetchUserDetailsByUserId(userId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching user details", dae);
		}
		return user;
	}

	@Override
	public List<AllCourses> fetchAllCoursesPresent(Integer userId) {
		List<AllCourses> coursesList = null;
		try {
			coursesList = myBatisDao.fetchAllCoursesPresent(userId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return coursesList;
	}

	@Override
	public List<StudentGrades> fetchGradesById(Integer userId) {
		List<StudentGrades> gradesList = null;
		try {
			gradesList = myBatisDao.fetchGradesById(userId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Grade details", dae);
		}
		return gradesList;
	}

	@Override
	public List<AllCourses> fetchCoursesForStudent(Integer userId) {
		List<AllCourses> studentCoursesList = null;
		try {
			studentCoursesList = myBatisDao.fetchCoursesForStudent(userId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return studentCoursesList;
	}

	@Override
	public List<AllCourses> fetchCoursesForProfessor(Integer userId) {
		List<AllCourses> professorCoursesList = null;
		try {
			professorCoursesList = myBatisDao.fetchCoursesForProfessor(userId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return professorCoursesList;
	}

	@Override
	public void insertCourseForStudent(Integer studentId, Integer courseId) {
		
		try {
			myBatisDao.insertCourseForStudent(studentId, courseId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
	}

	@Override
	public List<Department> fetchAllDepartments() {
		List<Department> deptList = null;
		try {
			deptList = myBatisDao.fetchAllDepartments();
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return deptList; 
	}

	@Override
	public void insertCourse(Integer courseId, String courseName, String courseDescription) {
		try {
			myBatisDao.insertCourse(courseId, courseName, courseDescription);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}	
	}

	@Override
	public void insertCourseForProfessor(Integer professorId, Integer courseId, Integer deptId) {
		try {
			myBatisDao.insertCourseForProfessor(professorId, courseId, deptId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		
	}

	@Override
	public List<StudentGrades> fetchStudentsByCourse(int courseId) {
		List<StudentGrades> stuList = null;
		try {
			stuList = myBatisDao.fetchStudentsByCourse(courseId);
		} catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return stuList; 
	}

	@Override
	public AllCourses checkIfCourseAlreadyPresent(Integer courseId) {
		AllCourses course = null;
		try {
			course = myBatisDao.checkIfCourseAlreadyPresent(courseId);
		}catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while fetching Courses details", dae);
		}
		return course; 
	}

	@Override
	public void gradeStudentForCourse(int id, String grade) {
		try {
			myBatisDao.gradeStudentForCourse(id, grade);
		}catch (DataAccessException dae) {
			// Always log the messages properly
			logger.error("Exception occured while inserting grades", dae);
		}		
	}

}
