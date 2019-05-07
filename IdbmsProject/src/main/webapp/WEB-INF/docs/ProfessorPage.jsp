<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.3.1/css/all.css"
	integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU"
	crossorigin="anonymous">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.8.10/themes/smoothness/jquery-ui.css"
	type="text/css">
<script type="text/javascript"
	src="//ajax.aspnetcdn.com/ajax/jquery.ui/1.8.10/jquery-ui.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
<title>Professor Home Page</title>

<style>
* {
	box-sizing: border-box;
}

/* Add padding to containers */
.container {
	padding: 16px;
	background-color: white;
}

/* Full-width input fields */
input[type=text], input[type=password] {
	width: 100%;
	padding: 15px;
	margin: 5px 0 22px 0;
	display: inline-block;
	border: none;
	background: #f1f1f1;
}

/* Set a style for the submit button */
.registerbtn {
	background-color: #3b5998;
	color: white;
	padding: 10px 10px;
	margin: 8px 0;
	border: none;
	cursor: pointer;
	width: 100%;
	opacity: 0.9;
}

.registerbtn:hover {
	opacity: 1;
}
</
s
</style>
</head>
<body>

	<script>
var id= null;
function addCourse() {
		// Insert the Course
		 $.ajax({
                type: "post",
                url: "/Idbms-Project/addCourse",
                contentType: "application/json",
                data: JSON.stringify({
                					courseId : $('#courseId').val(), 
                					courseName: $('#courseName').val(),
                					courseDescription : $("#courseDesc").val(),
                					deptId: $('#deptId').val() 
                					}),                 	
                success: function(msg){ 
                	if(msg.status == 400 || msg.status == 500){
                 		// Course already exists or Server error
                 		alert(msg.entity);
                 	} else {
                	alert("Course Added Successfully !!");
                	location.reload(true);
                	}
                }
            });					
}

function grade(){
	var grade = $("#grade").val();
	$.ajax({
        type: "post",
        url: "/Idbms-Project/gradeStudent?id="+id+"&grade="+grade,
        contentType: "application/json",                	
        success: function(msg){ 
        	if(msg.status == 400 || msg.status == 500){
         		// Course already exists or Server error
         		alert(msg.entity);
         	} else {
        	alert("Graded Successfully !!");
        	location.reload(true);
        	}
        }
    });	
}

function showText(gradeId){
	id = gradeId;
	
	$("#gradeHeader").html("Grade ");
	
	$("#gradeModal").modal();
}

function fetchStudentList(courseId, courseName){
	$.ajax({
        type: "get",
        url: "/Idbms-Project/fetchCourse?courseId="+courseId,
        contentType: "application/json",                 	
        success: function(msg){
        	
        	var modalBody = "<div class='table-responsive'><table class='table'><thead><tr><th>Student ID</th><th>Student Name</th><th>Grade</th></tr></thead><tbody>";
        	// Parsing Fetched Message
        	msg = $.parseJSON(msg);
        	$.each(msg, function(i, courseDetail) {
        		var grade = "";
        		var stuName = courseDetail.studentName+'';
        		if(courseDetail.grade != null && courseDetail.grade != ''){
        			grade = courseDetail.grade;
        		} else {
        			// Form a Href
        			grade = "Not Graded Yet, Grade here -> <a href='javascript:showText("+courseDetail.id+")'>Grade Here</a>";
        		}
        		
        		modalBody = modalBody + 
        		"<tr><td>"+courseDetail.studentId+"</td><td>"+courseDetail.studentName+"</td><td>"+grade+"</td></tr></tbody>";
        	});
        	
        	// Show in Modal Box
        	
        	// Set Header
        	$("#modalHeader").html(courseId + " - "+ courseName);
        	
        	// Set Modal Body
        	$("#modalBody").html(modalBody);
        	
        	$("#studentsModal").modal();
        	console.log(msg);
        }
    });
}

//Logout
function logout(){
	$("#stuForm").attr("action", "/Idbms-Project/logout").submit();
}

</script>
<form id="stuForm" action="get">

	<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#">Professor Home Page</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="#courses" data-toggle="pill">Your
					Courses/ Grade for Students</a></li>
			<li><a href="#addcourse" data-toggle="pill">Add New Course</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
		
			<li><a href="javascript:logout()" data-toggle="pill"><span
					class="glyphicon glyphicon-log-out"></span> Logout</a></li>
		</ul>
	</div>
	</nav>
</form>
	<div class="container">
		<div class="tab-content">
			<div id="courses" class="tab-pane fade in active">

				<!-- Get Courses added by the Professor along with Student Details-->
				<div class="table-responsive">
					<table class="table">
						<thead>
							<tr>
								<th>Course ID</th>
								<th>Course Name</th>
								<th>Course Description</th>
								<th>See Students List</th>
							</tr>
						</thead>
						<tbody>
							<!-- Show All Courses -->
							<c:forEach var="courseDetail" items="${professorCourses}">
								<tr>
									<td>${courseDetail.courseId}</td>
									<td>${courseDetail.courseName}</td>
									<td>${courseDetail.courseDescription}</td>
									<td><a
										href="javascript:fetchStudentList(${courseDetail.courseId}, 
															'${courseDetail.courseName}')">See
											Students List</a></td>
								</tr>
						</tbody>
						</c:forEach>
					</table>
				</div>

			</div>

			<div id="addcourse" class="tab-pane fade">
				<div class="container">
					<form action="javascript:addCourse()" method="post">
						<div class="container">
							<h1 align="center">Add New Course</h1>

							<label for="courseID"><b>Course ID:</b></label> <input
								type="text" placeholder="Enter Course ID" name="courseId"
								id="courseId" required> <label for="courseName"><b>Course
									Name:</b></label><input type="text" placeholder="Enter Course Name"
								name="courseName" id="courseName" required> <label
								for="courseDesc"><b>Course Description:</b></label><input
								type="text" placeholder="Enter Course Description"
								name="courseDesc" id="courseDesc" required> <label>Department:</label>
							<select id="deptId" name="deptId">
								<c:forEach var="dept" items="${departments}">
									<option value="${dept.departmentId}">${dept.departmentDescription}</option>
								</c:forEach>

							</select>

							<button type="submit" class="registerbtn">Add Course</button>
						</div>

					</form>
				</div>
			</div>

			<!-- To Show Students of a CourseId -->
			<!-- Modal -->
			<div class="modal fade" id="studentsModal" role="dialog">
				<div class="modal-dialog">

					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title" id="modalHeader"></h4>
						</div>
						<div class="modal-body" id="modalBody">
							<!-- Modal Body -->
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default"
								data-dismiss="modal">Close</button>
						</div>
					</div>

				</div>
			</div>
	
			
			<div class="modal fade" id="gradeModal" role="dialog">
				<div class="modal-dialog">

					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title" id="gradeHeader"></h4>
						</div>
						<div class="modal-body" id="gradeBody">
							<label for="grade"><b>Enter Grade for Student :</b></label> <input type="text"
							placeholder="Enter Grade" id="grade" maxLength="2" name="grade" required>
							<button type="submit"  class="registerbtn" onclick="grade()">Grade Student</button>
						</div>	
						<div class="modal-footer">
							<button type="button" class="btn btn-default"
								data-dismiss="modal">Close</button>
						</div>
					</div>

				</div>
			</div>

		</div>
</body>

</html>