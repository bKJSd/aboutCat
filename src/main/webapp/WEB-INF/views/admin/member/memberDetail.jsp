<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>


 <script>
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 1){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('address1_new').value = fullRoadAddr;
                document.getElementById('address1_old').value = data.jibunAddress;

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
</script>
<script>
function fn_modify_member_info(member_id,mod_type){
	var value;
		var frm_mod_member=document.frm_mod_member;
		if(mod_type=='member_pw'){
			value=frm_mod_member.member_pw.value;
		}else if(mod_type=='member_gender'){
			var member_gender=frm_mod_member.member_gender;
			for(var i=0; member_gender.length;i++){
			 	if(member_gender[i].checked){
					value=member_gender[i].value;
					break;
				} 
			}
			
		}else if(mod_type=='member_birth'){
			var birth_year=frm_mod_member.birth_year;
			var birth_month=frm_mod_member.birth_month;
			var birth_day=frm_mod_member.birth_day;
			var birth_day_yinyang=frm_mod_member.birth_day_yinyang;
			
			for(var i=0; birth_year.length;i++){
			 	if(birth_year[i].selected){
					value_y=birth_year[i].value;
					break;
				} 
			}
			for(var i=0; birth_month.length;i++){
			 	if(birth_month[i].selected){
					value_m=birth_month[i].value;
					break;
				} 
			}
			
			for(var i=0; birth_day.length;i++){
			 	if(birth_day[i].selected){
					value_d=birth_day[i].value;
					break;
				} 
			}
			
			for(var i=0; birth_day_yinyang.length;i++){
			 	if(birth_day_yinyang[i].checked){
					value_gn=birth_day_yinyang[i].value;
					break;
				} 
			}
			value=+value_y+","+value_m+","+value_d+","+value_gn;
		}else if(mod_type=='phone'){
			var value_phone=frm_mod_member.phone.value;

			var sms_valid_check=frm_mod_member.sms_valid_check;
			
			value_sms_valid_check=sms_valid_check.checked;
			
			value=value_phone+","+value_sms_valid_check;
			
		}else if(mod_type=='email'){
			var member_email1=frm_mod_member.member_email1;
			var member_email2=frm_mod_member.member_email2;
			var email_valid_check=frm_mod_member.email_valid_check;
			
			value_member_email1=member_email1.value;
			value_member_email2=member_email2.value;
			value_email_valid_check=email_valid_check.checked;
			
			
			value=value_member_email1+","+value_member_email2+","+value_email_valid_check;
		}else if(mod_type=='address'){
			var postcode=frm_mod_member.postcode;
			var address1_new=frm_mod_member.address1_new;
			var address1_old=frm_mod_member.address1_old;
			var address2=frm_mod_member.address2;
			
			value_postcode=postcode.value;
			value_address1_new=address1_new.value;
			value_address1_old=address1_old.value;
			value_address2=address2.value;
			
			value=value_postcode+","+value_address1_new+","+value_address1_old+","+value_address2;
		}
	 
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "/about_cat/admin/member/modifyMemberInfo.do",
			data : {
				member_id:member_id,
				mod_type:mod_type,
				value:value
			},
			success : function(data, textStatus) {
				if(data.trim()=='mod_success'){
					alert("회원 정보를 수정했습니다.");
				}else if(data.trim()=='failed'){
					alert("다시 시도해 주세요.");	
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				
			}
		}); //end ajax
}
function updateEmail2(selectElement) {
    var memberEmail2Input = document.getElementsByName("member_email2")[0];

    if (selectElement.value === "non") {
        // 직접입력을 선택한 경우
        memberEmail2Input.value = "";
        memberEmail2Input.disabled = false; // 입력 가능하도록 활성화
    } else {
        // 다른 옵션을 선택한 경우
        memberEmail2Input.value = selectElement.value;
        memberEmail2Input.disabled = true; // 입력 불가능하도록 비활성화
    }
}

function fn_delete_member(member_id ,member_deleted){
	var frm_mod_member=document.frm_mod_member;
	var i_member_id = document.createElement("input");
	var i_member_deleted = document.createElement("input");
    
	
    i_member_id.name="member_id";
    i_member_deleted.name="member_deleted";
    i_member_id.value=member_id;
    i_member_deleted.value=member_deleted;
    
    frm_mod_member.appendChild(i_member_id);
    frm_mod_member.appendChild(i_member_deleted);
    frm_mod_member.method="post";
    frm_mod_member.action="/about_cat/admin/member/deleteMember.do";
    frm_mod_member.submit();
}
</script>
</head>

<body>
	<h3>내 상세 정보</h3>
<form name="frm_mod_member">	
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">아이디</td>
					<td>
						<input name="member_id" type="text" size="20" value="${member_info.member_id }"  disabled/>
					</td>
					 <td>
					  <input type="button" value="수정하기" disabled onClick="fn_modify_member_info('${member_info.member_id }','member_name')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td>
					  <input name="member_pw" type="password" size="20" value="${member_info.member_pw }" />
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_pw')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td>
					  <input name="member_name" type="text" size="20" value="${member_info.member_name }"  disabled />
					 </td>
					 <td>
					  <input type="button" value="수정하기" disabled onClick="fn_modify_member_info('${member_info.member_id }','member_name')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">성별</td>
					<td>
					  <c:choose >
					    <c:when test="${member_info.member_gender =='101' }">
					      <input type="radio" name="member_gender" value="102" />
						  여성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <input type="radio" name="member_gender" value="101" checked />남성
					    </c:when>
					    <c:otherwise>
					      <input type="radio" name="member_gender" value="102"  checked />
						   여성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					      <input type="radio" name="member_gender" value="101"  />남성
					   </c:otherwise>
					   </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_gender')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">법정생년월일</td>
					<td>
					   <select name="birth_year">
					     <c:forEach var="i" begin="1" end="100">
					       <c:choose>
					         <c:when test="${member_info.birth_year==1920+i }">
							   <option value="${ 1920+i}" selected>${ 1920+i} </option>
							</c:when>
							<c:otherwise>
							  <option value="${ 1920+i}" >${ 1920+i} </option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>년 
					<select name="birth_month" >
						<c:forEach var="i" begin="1" end="12">
					       <c:choose>
					         <c:when test="${member_info.birth_month==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>월 
					
					<select name="birth_day">
							<c:forEach var="i" begin="1" end="31">
					       <c:choose>
					         <c:when test="${member_info.birth_day==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>일 
					
					   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <br>
					   <br>
					   <c:choose>
					    <c:when test="${member_info.birth_day_yinyang}"> 
					  <input type="radio" name="birth_day_yinyang" value="true" checked />양력
						&nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="birth_day_yinyang" value="false" />음력
						</c:when>
						<c:otherwise>
						  <input type="radio" name="birth_day_yinyang" value="true" />양력
						   &nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="birth_day_yinyang" value="false" checked  />음력
						</c:otherwise>
						</c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_birth')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td>
					 <input type="text" name="phone" size=12 value="${member_info.phone }">
					 <br>
					 <br>
					 <c:choose> 
					   <c:when test="${member_info.sms_valid_check}">
					     <input type="checkbox"  name="sms_valid_check" value="true" checked /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox"  name="sms_valid_check" value="false"  /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:otherwise>
					 </c:choose>	
				    </td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','phone')" />
					</td>	
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일(e-mail)</td>
					<td>
					   <input type="text" name="member_email1" size=12 value="${member_info.member_email1 }" /> 
					   <input type="text" size=14  name="member_email2" value="${member_info.member_email2 }" /> 
					   <select name="select_member_email2" onChange="updateEmail2(this)"  title="직접입력">
							<option value="non">직접입력</option>
							<option value="@hanmail.net">hanmail.net</option>
							<option value="@naver.com">naver.com</option>
							<option value="@yahoo.co.kr">yahoo.co.kr</option>
							<option value="@hotmail.com">hotmail.com</option>
							<option value="@paran.com">paran.com</option>
							<option value="@nate.com">nate.com</option>
							<option value="@google.com">google.com</option>
							<option value="@gmail.com">gmail.com</option>
							<option value="@empal.com">empal.com</option>
							<option value="@korea.com">korea.com</option>
							<option value="@freechal.com">freechal.com</option>
					</select><Br><br> 
					<c:choose> 
					   <c:when test="${member_info.email_valid_check}">
					     <input type="checkbox" name="email_valid_check"  value="true" checked /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox" name="email_valid_check"  value="false"  /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:otherwise>
					 </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','email')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   <input type="text" id="postcode" name="postcode" size=5 value="${member_info.postcode }" > <button><a href="javascript:execDaumPostcode()">우편번호검색</a></button>
					  <br>
					  <p> 
					   지번 주소:<br><input type="text" id="address1_new"  name="address1_new" size="50" value="${member_info.address1_new }"><br><br>
					  도로명 주소: <input type="text" id="address1_old" name="address1_old" size="50" value="${member_info.address1_old }"><br><br>
					  나머지 주소: <input type="text"  name="address2" size="50" value="${member_info.address2 }" />
					   <span id="guide" style="color:#999"></span>
					   </p>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','address')" />
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		<div class="clear">
		<br><br>
		<table align=center>
		<tr>
			<td >
				<input type="hidden" name="command"  value="modify_my_info" /> 
				<c:choose>
				  <c:when test="${member_info.member_deleted}">
				    <input  type="button"  value="회원복원" onClick="fn_delete_member('${member_info.member_id }',false)">   
				  </c:when>
				  <c:otherwise>
				    <input  type="button"  value="회원탈퇴" onClick="fn_delete_member('${member_info.member_id }',true)">
				  </c:otherwise>
				</c:choose>
				
			</td>
		</tr>
	</table>
	</div>
</form>	
</body>
</html>
