package project.idbms.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.core.Response;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import project.idbms.service.MyBatisService;
import project.idbms.view.CourseView;
import project.idbms.view.UserView;
import project.idbms.db.AllCourses;
import project.idbms.db.Department;
import project.idbms.db.StudentGrades;
import project.idbms.db.University;
import project.idbms.db.User;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

// Rest Controller Annotation [A Specialized version of the @Controller annotation]
// It is a combination of @Controller+ @ResponseBody
// So that we no need to add @ResponseBody annotation to Request Mapping methods.
@RestController
public class MyBatisController {

	// Autowired annotation is a new style of Dependency Injection Drive
	@Autowired
	MyBatisService myBatisService;

	private static final Logger logger = Logger.getLogger(MyBatisController.class);
	private static final String ERROR_PAGE_VIEW = "exceptionpage";
	private static final String UNIVERSITY_PAGE_VIEW = "UniversityHome";
	private static final String PROFESSOR_PAGE_VIEW = "ProfessorPage";
	private static final String STUDENT_PAGE_VIEW = "StudentPage";
	private static Random rand = new Random((new Date()).getTime());

	/**
	 * 
	 * Home Page for the Doctor Queue
	 * 
	 */
	@RequestMapping(path = "/universityhome", method = RequestMethod.GET)
	public ModelAndView universityHomePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		// Setting Error Page Initially, Later we will be changing it.
		modelAndView.setViewName(ERROR_PAGE_VIEW);
		try {
			List<University> univList = new ArrayList<>();
			univList = myBatisService.fetchUnivDetails();
			modelAndView.addObject("universityList", univList);
			modelAndView.setViewName(UNIVERSITY_PAGE_VIEW);
		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
		return modelAndView;
	}

	@RequestMapping(path = "/enrollToCourse", method = RequestMethod.POST)
	public void enrollToCourse(HttpServletRequest request, HttpServletResponse response, @RequestParam int courseId)
			throws Exception {
		HttpSession httpSession = request.getSession();
		try {
			// Fetch Student Id
			Integer studentId = (Integer) httpSession.getAttribute("userId");

			// Insert to Students Table
			myBatisService.insertCourseForStudent(studentId, courseId);
		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
	}

	// Fetch Students along with Courses for a Course ID
	@RequestMapping(path = "/fetchCourse", method = RequestMethod.GET)
	public String fetchStudentsByCourse(HttpServletRequest request, HttpServletResponse response,
			@RequestParam int courseId) throws Exception {
		String studentsDet = "";
		try {
			List<StudentGrades> studentsList = myBatisService.fetchStudentsByCourse(courseId);

			// Converting to Json
			Gson gson = new Gson();
			studentsDet = gson.toJson(studentsList);

		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
		return studentsDet;
	}

	@RequestMapping(path = "/gradeStudent", method = RequestMethod.POST)
	public Response gradeStudentForCourse(HttpServletRequest request, HttpServletResponse response,
			@RequestParam int id, @RequestParam String grade) throws Exception {
		HttpSession httpSession = request.getSession();
		try {
			if (id > 0) {
				// Insert to Grades Table
				myBatisService.gradeStudentForCourse(id, grade);
				return Response.status(Response.Status.OK).entity("Success !!").build();
			}
		} catch (Exception exception) {
			logger.error("Exception occured while inserting user Details : ", exception);
		}
		return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Error when registering user !!").build();
	}

	@RequestMapping(path = "/addCourse", method = RequestMethod.POST)
	public Response addCourse(HttpServletRequest request, HttpServletResponse response,
			@RequestBody CourseView courseView) throws Exception {
		HttpSession httpSession = request.getSession();
		try {
			// Fetch Professor Id
			Integer professorId = (Integer) httpSession.getAttribute("userId");

			// Check if the Course is already present before Inserting
			AllCourses course = myBatisService.checkIfCourseAlreadyPresent(courseView.getCourseId());

			if (course != null) {
				// Throw Error Saying the Course already exists
				return Response.status(Response.Status.BAD_REQUEST)
						.entity("Course Id already Exists - Please create another one !!").build();
			} else {
				// Insert into Course Table
				myBatisService.insertCourse(courseView.getCourseId(), courseView.getCourseName(),
						courseView.getCourseDescription());

				// Insert to Professor Table
				myBatisService.insertCourseForProfessor(professorId, courseView.getCourseId(), courseView.getDeptId());

				return Response.status(Response.Status.OK).entity("Success !!").build();
			}
		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
		return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Error when adding new Course !!").build();
	}

	@RequestMapping(path = "/homePage", method = RequestMethod.GET)
	public ModelAndView homePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		// Setting Error Page Initially, Later we will be changing it.
		modelAndView.setViewName(ERROR_PAGE_VIEW);
		HttpSession httpSession = request.getSession();
		try {
			if (httpSession != null && httpSession.getAttribute("userId") != null) {
				Integer userId = (Integer) httpSession.getAttribute("userId");
				String role = (String) httpSession.getAttribute("role");

				modelAndView.addObject("userId", userId);

				if (role.equalsIgnoreCase("Student")) {

					// Fetch all grades for the Student
					List<StudentGrades> studentGrades = myBatisService.fetchGradesById(userId);
					// Adding to Model Object
					modelAndView.addObject("studentGrades", studentGrades);

					// Fetch all Courses present
					List<AllCourses> allCourses = myBatisService.fetchAllCoursesPresent(userId);
					// Adding to model object
					modelAndView.addObject("allCoursesPresent", allCourses);

					modelAndView.setViewName(STUDENT_PAGE_VIEW);

				} else {
					modelAndView.setViewName(PROFESSOR_PAGE_VIEW);

					// Fetch all Departments
					List<Department> departmentList = myBatisService.fetchAllDepartments();
					modelAndView.addObject("departments", departmentList);

					// Fetch Courses Tied to a Professor By Id
					List<AllCourses> professorCourses = myBatisService.fetchCoursesForProfessor(userId);
					// Adding to model object
					modelAndView.addObject("professorCourses", professorCourses);

				}

			} else {
				// Navigate to University Home Page
				return new ModelAndView("redirect:/universityHome");
			}
		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
		return modelAndView;
	}

	// Logout
	@RequestMapping(path = "/logout", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) {
		HttpSession httpSession = request.getSession();
		if (httpSession != null && httpSession.getAttribute("userId") != null) {
			// Log User Out & remove Session
			httpSession.removeAttribute("userId");
			httpSession.removeAttribute("role");
		}
		return new ModelAndView("redirect:/universityHome");
	}

	@RequestMapping(path = "/registerUser", method = RequestMethod.POST)
	public Response universityRegisterPage(HttpServletRequest request, HttpServletResponse response,
			@RequestBody UserView userView) throws Exception {
		HttpSession httpSession = request.getSession();
		try {
			// Get all attributes from the Form
			Integer userId = userView.getUserId();
			String password = userView.getPassword();
			String role = userView.getRole();
			String username = userView.getUserName();

			String encryptedPassword = encrypt(password);

			// Check if user already exists
			User user = myBatisService.fetchUserDetailsByUserId(userId);
			if (user != null) {
				// User already exists, Throw Error
				return Response.status(Response.Status.BAD_REQUEST).entity("User already Exists - Please Login!!")
						.build();
			} else {
				// Insert into Database and Set to Session
				myBatisService.registerUser(userId, encryptedPassword, role, username);

				// Set in Session the userId
				httpSession.setAttribute("userId", userId);
				httpSession.setAttribute("role", role);
				return Response.status(Response.Status.OK).entity("Success !!").build();
			}
		} catch (Exception exception) {
			logger.error("Exception occured while inserting user Details : ", exception);
		}
		return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Error when registering user !!").build();
	}

	@RequestMapping(path = "/loginUser", method = RequestMethod.POST)
	public Response universityLoginPage(HttpServletRequest request, HttpServletResponse response,
			@RequestBody UserView userView) throws Exception {
		HttpSession httpSession = request.getSession();
		try {
			// Get all attributes from the Form
			Integer userId = userView.getUserId();
			String password = userView.getPassword();

			// Check if user exists
			User user = myBatisService.fetchUserDetailsByUserId(userId);
			if (user == null) {
				// User already exists, Throw Error
				return Response.status(Response.Status.BAD_REQUEST).entity("User doesn't Exist - Please Register!!")
						.build();
			} else {

				// Check if Passwords are same
				if (user.getPassword() != null && decrypt(user.getPassword()).equals(password)) {
					// Go to Home Page
					// Set in Session the userId
					httpSession.setAttribute("userId", userId);
					httpSession.setAttribute("role", user.getRole());
					return Response.status(Response.Status.OK).entity("Success !!").build();
				} else {
					// Password Incorrect error
					return Response.status(Response.Status.BAD_REQUEST)
							.entity("Password is Invalid - Please Enter Correct password!!").build();
				}
			}
		} catch (Exception exception) {
			logger.error("Exception occured while inserting user Details : ", exception);
		}
		return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Error when registering user !!").build();
	}

	@RequestMapping(path = "/redirectPage", method = RequestMethod.POST)
	public ModelAndView universityRedirectPage(HttpSession httpSession) throws Exception {
		try {
			if (httpSession != null && httpSession.getAttribute("userId") != null) {
				return new ModelAndView("redirect:/homePage");
			}
		} catch (Exception exception) {
			logger.error("Exception occured while getting Home Page : ", exception);
		}
		return new ModelAndView("redirect:/universityHome");
	}

	// Encrypting the Password
	public static String encrypt(String str) {
		BASE64Encoder encoder = new BASE64Encoder();
		byte[] salt = new byte[8];
		rand.nextBytes(salt);
		return encoder.encode(salt) + encoder.encode(str.getBytes());
	}

	// Decrypting the Password
	public static String decrypt(String encstr) {
		if (encstr.length() > 12) {
			String cipher = encstr.substring(12);
			BASE64Decoder decoder = new BASE64Decoder();
			try {
				return new String(decoder.decodeBuffer(cipher));
			} catch (IOException e) {
				// throw new InvalidImplementationException(
				// Fail
			}
		}
		return null;
	}

}
