
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta>
<title>University Home Page</title>
<meta charset="utf-8">
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

table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
	width: auto;
}
</style>
</head>

<body>

	<script>
		// Checking for Password Flag
		var isValidPassword = false;
		var check = function() {
			if ($("#regPassword").val() != "" || $("#regConfirmPassword").val()) {
				if ($("#regPassword").val() == $("#regConfirmPassword").val()) {
					$("#passwordMsg").css("color", "green");
					$("#passwordMsg").html('Passwords Matched');
					isValidPassword = true;
				} else {
					$("#passwordMsg").css("color", "red");
					$("#passwordMsg").html('Passwords Not Matching');
					isValidPassword = false;
				}
			} else {
				$("#passwordMsg").css("color", "");
				$("#passwordMsg").html('');
			}
		}

		function registerUser() {
			if (!isValidPassword) {
				// Throw Passwords Mismatch
				alert("Passwords Mismatch -- Please enter valid passwords");
			} else {
				// Insert the User
				$.ajax({
					type : "post",
					url : "/Idbms-Project/registerUser",
					contentType : "application/json",
					data : JSON.stringify({
						userId : $('#reguserid').val(),
						password : $('#regPassword').val(),
						userName : $("#regusername").val(),
						role : $('#regrole').val()
					}),
					success : function(msg) {
						if (msg.status == 400 || msg.status == 500) {
							// User already exists or Server error
							alert(msg.entity);
						} else if (msg.status == 200) {
							// Navigate to Student/ Professor page
							$("#registerForm").attr("action",
									"/Idbms-Project/redirectPage").submit();
						}
					}
				});
			}
		}

		// Login
		function loginUser() {
			$.ajax({
				type : "post",
				url : "/Idbms-Project/loginUser",
				contentType : "application/json",
				data : JSON.stringify({
					userId : $('#loginuserid').val(),
					password : $('#loginpassword').val()
				}),
				success : function(msg) {
					if (msg.status == 400 || msg.status == 500) {
						// User already exists or Server error
						alert(msg.entity);
					} else if (msg.status == 200) {
						// Navigate to Student/ Professor page
						$("#loginForm").attr("action",
								"/Idbms-Project/redirectPage").submit();
					}
				}
			});
		}
	</script>

	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">University of Missouri</a>
			</div>
			<ul class="nav navbar-nav">
				<li class="active"><a href="#home" data-toggle="pill">Home</a></li>
				<li><a href="#about" data-toggle="pill">About</a></li>
				<li><a href="#universities" data-toggle="pill">Universities
						List</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="#signup" data-toggle="pill"><span
						class="glyphicon glyphicon-user"></span> Sign Up</a></li>
				<li><a href="#login" data-toggle="pill"><span
						class="glyphicon glyphicon-log-in"></span> Login</a></li>
			</ul>
		</div>
	</nav>

	<div class="container">
		<div class="tab-content">
			<div id="home" class="tab-pane fade in active">

				<h3>Welcome to University Page</h3>
				<div class="panel panel-primary">
					<div class="panel-heading">University of Missouri</div>
					<div class="panel-body">Multiple regions, Multiple religions,
						Under One University roof !!</div>
						
						<img src="https://ewscripps.brightspotcdn.com/dims4/default/9212bdd/2147483647/strip/true/crop/640x360+0+60/resize/1280x720!/quality/90/?url=https%3A%2F%2Fmediaassets.kshb.com%2Fphoto%2F2015%2F02%2F01%2Fumkc1_1422811200282_12927592_ver1.0_640_480.JPG" width ="1135" height="400"/>
				</div>
			</div>

			<div id="about" class="tab-pane fade">
				<div class="container">
					<h2>University of Missouri  Group</h2>
					
					<div class="panel-group">
						<div class="panel panel-primary">
							<div class="panel-heading">University of Missouri - Kansas
								City</div>
							<div class="panel-body" align="justify">The University of Missouri-Kansas
								City (UMKC) is a public research university in Kansas City,
								Missouri. UMKC is one of four campuses that collectively
								constitute the University of Missouri System, and one of only
								two with a medical school. As of 2015, the university's
								enrollment exceeded 16,000 students. It is the largest college
								in the Kansas City metropolitan area. UMKC is spread across
								multiple locales; the main Volker Campus, home to most
								university operations, is located in Kansas City's Rockhill
								neighbourhood, east of the Country Club Plaza, and adjacent to
								both the Stowers Institute for Medical Research and the
								world-renowned Linda Hall Library. In 2017 the University, in
								collaboration with Truman Medical Centre, Children's Mercy
								Hospital, the Missouri Health Department, the Jackson County
								Medical Examiners Office, and the Missouri Department of Mental
								Health Behavioral Medicine, formed the UMKC Health Sciences
								District on Hospital Hill. This district is a
								first-in-the-nation partnership between local and state
								governments, the university, and these nationally recognized
								healthcare faculties, designed to promote collaboration in
								research, innovation, education, grant funding, and community
								outreach, for the advancement of health and wellness in the
								greater Kansas City metropolitan area. Also in 2017, the
								university announced plans to expand its metropolitan identity
								with the construction of a downtown Campus for the Arts, located
								near the huffman Center for the Performing Arts.</div>
						</div>
						<div class="panel panel-primary">
							<div class="panel-heading">University of Missouri - Rolla</div>
							<div class="panel-body"  align="justify">Missouri S&T, or Missouri
								University of Science and Technology, is a public land grant and
								space grant university in Rolla, Missouri. It is a member
								institution of the University of Missouri System. Most of its
								8,884 students (fall 2017) study engineering, business,
								sciences, and mathematics. Known primarily for its engineering
								school, Missouri S&T offers degree programs in business and
								management systems, information science and technology,
								sciences, social sciences, humanities, and arts Missouri S&T was
								founded in 1870 as the Missouri School of Mines and Metallurgy
								(MSM), the first technological learning institution west of the
								Mississippi River. Early in its history, the School of Mines was
								focused primarily on mining and metallurgy. Rolla is located
								close to the Southeast Missouri Lead District which produces
								about 70% of the U.S. primary supply of lead as well as
								significant amounts of the nation's zinc. In making the case for
								changing the name, then Chancellor John F. Carney III noted that
								Rolla in 2007 was "one of the few technological research
								universities in the nation. A technological research university
								(polytechnic university or institute of technology) may be
								defined as one in which a majority of students are enrolled in
								engineering, the sciences, business or mathematics; the graduate
								and research programs in those fields are robust; and
								exceptional academic programs in the liberal arts, humanities
								and social sciences complement and provide context to the
								technological strengths of the institution." He noted that more
								than 70 percent of its enrollment was in engineering and more
								than 90 percent was in engineering, business, science and
								math—significantly higher than engineering schools such as the
								Massachusetts Institute of Technology, Georgia Institute of
								Technology, and Rensselaer Polytechnic Institute.</div>
						</div>

					</div>
				</div>

			</div>
			<div id="universities" class="tab-pane fade">
				<table class="table">
					<tr>
						<th>Name</th>
						<th>Location</th>
						<th>Image</th>
					</tr>
					<c:forEach items="${universityList}" var="item">
						<tr>
							<td>${item.name}</td>
							<td>${item.loc}</td>
							<td><img src="${item.link}" height="100" width="500"></td>
						</tr>
					</c:forEach>
				</table>

			</div>
			<div id="signup" class="tab-pane fade">
				<form id="registerForm" action="javascript:registerUser();"
					method="post">
					<div class="container">
						<h1 align="center">Register</h1>
						<label for="userID"><b>User ID:</b></label> <input type="text"
							placeholder="Enter User ID" id="reguserid" maxLength="9"
							name="reguserid" required> <label for="userName"><b>User
								Name:</b></label> <input type="text" placeholder="Enter UserName"
							id="regusername" maxLength="30" name="regusername" required>
						<label for="psw"><b>Password</b></label> <input type="password"
							placeholder="Enter Password" maxLength="20" name="regPassword"
							id="regPassword" onkeyup="check()" required> <label
							for="psw-repeat"><b>Repeat Password</b></label> <input
							type="password" placeholder="Repeat Password" maxLength="20"
							name="regConfirmPassword" required onkeyup="check()"
							id="regConfirmPassword">

						<p id="passwordMsg"></p>

						<label>Role:</label> <select id="regrole" name="regrole">
							<option value="student">Student</option>
							<option value="professor">Professor</option>
						</select>

						<button type="submit" class="registerbtn">Register</button>
					</div>

					<div class="container signin">
						<p>
							Already have an account? <a href="#login">Sign in</a>.
						</p>
					</div>
				</form>
			</div>
			<div id="login" class="tab-pane fade">
				<form id="loginForm" action="javascript:loginUser();" method="post">
					<div class="container">
						<h1 align="center">Login</h1>

						<label for="userID"><b>User ID:</b></label> <input type="text"
							placeholder="Enter User ID" name="loginuserid" id="loginuserid"
							required> <label for="password"><b>Password:</b></label><input
							type="password" placeholder="Enter Password" id="loginpassword"
							name="loginpassword" required>

						<button type="submit" class="registerbtn">Login</button>
					</div>

				</form>
			</div>

		</div>
</body>