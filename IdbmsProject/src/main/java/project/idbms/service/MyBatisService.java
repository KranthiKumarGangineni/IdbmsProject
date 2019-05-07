package project.idbms.service;

import java.util.List;

import project.idbms.db.AllCourses;
import project.idbms.db.Department;
import project.idbms.db.StudentGrades;
import project.idbms.db.University;
import project.idbms.db.User;

public interface MyBatisService {

	List<University> fetchUnivDetails();

	void registerUser(Integer userId, String encryptedPassword, String role, String username);

	User fetchUserDetailsByUserId(Integer userId);

	List<AllCourses> fetchAllCoursesPresent(Integer userId);

	List<StudentGrades> fetchGradesById(Integer userId);

	List<AllCourses> fetchCoursesForStudent(Integer userId);

	List<AllCourses> fetchCoursesForProfessor(Integer userId);

	void insertCourseForStudent(Integer studentId, Integer courseId);

	List<Department> fetchAllDepartments();

	void insertCourse(Integer courseId, String courseName, String courseDescription);

	void insertCourseForProfessor(Integer professorId, Integer courseId, Integer deptId);

	List<StudentGrades> fetchStudentsByCourse(int courseId);

	AllCourses checkIfCourseAlreadyPresent(Integer courseId);

	void gradeStudentForCourse(int id, String grade);
	
	
}
