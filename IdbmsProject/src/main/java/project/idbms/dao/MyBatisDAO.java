package project.idbms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.dao.DataAccessException;

import project.idbms.db.AllCourses;
import project.idbms.db.Department;
import project.idbms.db.StudentGrades;
import project.idbms.db.University;
import project.idbms.db.User;

@Mapper
public interface MyBatisDAO {

	List<University> fetchUnivDetails() throws DataAccessException;

	void registerUser(@Param("userId") Integer userId, @Param("encryptedPassword") String encryptedPassword,
											@Param("role") String role, @Param("username")String username);

	User fetchUserDetailsByUserId(@Param("userId") Integer userId);

	List<AllCourses> fetchAllCoursesPresent(@Param("userId") Integer userId);

	List<StudentGrades> fetchGradesById(@Param("userId") Integer userId);

	List<AllCourses> fetchCoursesForStudent(@Param("userId") Integer userId);

	List<AllCourses> fetchCoursesForProfessor(@Param("userId") Integer userId);

	void insertCourseForStudent(@Param("userId") Integer studentId,@Param("courseId") Integer courseId);

	List<Department> fetchAllDepartments();

	void insertCourse(@Param("courseId")Integer courseId, @Param("courseName")String courseName, 
						@Param("courseDescription")String courseDescription);

	void insertCourseForProfessor(@Param("professorId")Integer professorId, @Param("courseId")Integer courseId, 
											@Param("deptId")Integer deptId);

	List<StudentGrades> fetchStudentsByCourse(@Param("courseId")int courseId);

	AllCourses checkIfCourseAlreadyPresent(@Param("courseId")Integer courseId);

	void gradeStudentForCourse(@Param("gradeId") int id,@Param("grade") String grade);

}
