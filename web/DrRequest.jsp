<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Request</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            background-color: #f9f9f9;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px 0;
        }
        
        /* Specific styling only for this doctor request form */
        .doctor-request-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .doctor-request-form {
            background: linear-gradient(135deg, #CCFFFF 0%, #E6F7FF 100%);
            padding: 30px;
            margin: 40px auto;
            width: fit-content;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 91, 153, 0.2);
            border: 2px solid #66CCCC;
            font-size: 16px;
            color: #003366;
        }
        
        .doctor-request-form .page-header {
            font-size: 28px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 25px;
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 3px solid #CCFFFF;
        }
        
        .doctor-request-form .form-grid {
            display: block;
        }
        
        .doctor-request-form .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .doctor-request-form .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .doctor-request-form .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .doctor-request-form .form-label {
            font-size: 16px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 8px;
            background-color: #CCFFFF;
            padding: 8px 12px;
            border-radius: 4px;
        }
        
        .doctor-request-form .form-input,
        .doctor-request-form .form-select,
        .doctor-request-form .form-textarea {
            padding: 12px 15px;
            font-size: 16px;
            border: 2px solid #003366;
            border-radius: 6px;
            background-color: #ffffff;
            color: #333333;
            transition: border-color 0.2s ease;
            font-family: Arial, sans-serif;
        }
        
        .doctor-request-form .form-input:focus,
        .doctor-request-form .form-select:focus,
        .doctor-request-form .form-textarea:focus {
            outline: none;
            border-color: #0066CC;
            box-shadow: 0 0 5px rgba(0, 102, 204, 0.3);
        }
        
        .doctor-request-form .form-input::placeholder {
            color: #999999;
        }
        
        .doctor-request-form .form-select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23003366' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
            font-weight: bold;
        }
        
        .doctor-request-form .form-select option {
            font-size: 18px;
            font-weight: bold;
            padding: 12px;
            color: #003366;
        }
        
        .doctor-request-form .form-textarea {
            resize: vertical;
            min-height: 100px;
            font-family: Arial, sans-serif;
        }
        
        .doctor-request-form .other-entry-container {
            margin-top: 10px;
            padding: 15px;
            background-color: #f0f8ff;
            border-radius: 6px;
            border: 1px solid #CCFFFF;
            display: none;
        }
        
        .doctor-request-form .other-entry-container.show {
            display: block;
        }
        
        .doctor-request-form .form-buttons {
            text-align: center;
            margin-top: 25px;
        }
        
        .doctor-request-form .btn {
            background: linear-gradient(135deg, #005B99, #003366);
            color: white;
            border: none;
            padding: 14px 30px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
            min-width: 120px;
            margin: 0 10px;
        }
        
        .doctor-request-form .btn:hover {
            background: linear-gradient(135deg, #004070, #002244);
            transform: translateY(-1px);
        }
        
        .doctor-request-form .btn-secondary {
            background: linear-gradient(135deg, #666666, #444444);
        }
        
        .doctor-request-form .btn-secondary:hover {
            background: linear-gradient(135deg, #555555, #333333);
        }
        
        .doctor-request-form .required {
            color: #cc0000;
        }
        
        .doctor-request-form .form-hint {
            font-size: 12px;
            color: #666666;
            margin-top: 5px;
            font-style: italic;
        }
        
        /* Responsive for this form only */
        @media (max-width: 768px) {
            .doctor-request-container {
                padding: 10px;
            }
            
            .doctor-request-form {
                width: 95%;
                padding: 20px;
                margin: 20px auto;
            }
            
            .doctor-request-form .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .doctor-request-form .page-header {
                font-size: 24px;
            }
            
            .doctor-request-form .btn {
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>

    <script>
        function checkEntryPoint() {
            const select = document.getElementById('EntryPoint');
            const otherContainer = document.getElementById('otherEntryPointContainer');
            const otherInput = document.getElementById('otherEntryPoint');
            
            if (select.value === 'Other') {
                otherContainer.classList.add('show');
                otherInput.required = true;
            } else {
                otherContainer.classList.remove('show');
                otherInput.required = false;
                otherInput.value = '';
            }
        }

        window.onload = function() {
            checkEntryPoint();
            document.getElementById('EntryPoint').addEventListener('change', checkEntryPoint);
            
            // Set current date as default
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('CDate').value = today;
        };
    </script>
</head>
<body>
    <div class="doctor-request-container">
        <div class="doctor-request-form">
            <div class="page-header">
                Counsellor Interface
            </div>

            <form method="post" action="DrRequestSAve.jsp">
                <div class="form-grid">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="CDate" class="form-label">Date <span class="required">*</span></label>
                            <input type="date" name="CDate" id="CDate" class="form-input" required />
                        </div>
                        <div class="form-group">
                            <label for="SysPatientID" class="form-label">System Patient ID <span class="required">*</span></label>
                            <input type="number" name="SysPatientID" id="SysPatientID" min="1" class="form-input" required placeholder="Patient ID" />
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="EntryPoint" class="form-label">Entry Point <span class="required">*</span></label>
                            <select name="EntryPoint" id="EntryPoint" class="form-select" required>
                                <option value="">-- Select Entry Point --</option>
                                <option value="VCT">VCT</option>
                                <option value="OPD">OPD</option>
                                <option value="MUHABURA">MUHABURA</option>
                                <option value="Other">Other</option>
                            </select>
                            
                            <div id="otherEntryPointContainer" class="other-entry-container">
                                <label for="otherEntryPoint" class="form-label">Please specify:</label>
                                <input type="text" name="OtherEntryPoint" id="otherEntryPoint" class="form-input" placeholder="Specify other entry point" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="RequestDoctor" class="form-label">Requesting Doctor <span class="required">*</span></label>
                            <input type="text" name="RequestDoctor" id="RequestDoctor" class="form-input" required placeholder="Doctor's name" />
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label for="DoctorNotes" class="form-label">Notes <span class="required">*</span></label>
                            <textarea name="DoctorNotes" id="DoctorNotes" class="form-textarea" required placeholder="Enter notes..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-buttons">
                    <input type="submit" name="save" value="SAVE" class="btn" />
                </div>
            </form>

            <form method="post" action="main.do?CheckService=true&CheckMedicalCenter=true&ts=<%=System.currentTimeMillis()%>">
                <div class="form-buttons">
                    <input type="submit" name="back" value="BACK" class="btn btn-secondary" />
                </div>
            </form>
        </div>
    </div>
</body>
</html>