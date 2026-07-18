<!DOCTYPE html>
<html>
<head>
    <title>Exam View</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            background-color: #f9f9f9;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px 0;
        }
        
        /* Specific styling only for this exam view page */
        .exam-view-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .exam-view-form {
            background: linear-gradient(135deg, #CCFFFF 0%, #E6F7FF 100%);
            padding: 40px;
            margin: 40px auto;
            width: fit-content;
            min-width: 400px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 91, 153, 0.2);
            border: 2px solid #66CCCC;
            font-size: 16px;
            color: #003366;
        }
        
        .exam-view-form .page-header {
            font-size: 32px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 35px;
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 3px solid #66CCCC;
        }
        
        .exam-view-form .search-section {
            text-align: center;
            margin: 30px 0;
        }
        
        .exam-view-form .search-table {
            margin: 0 auto;
            border-collapse: collapse;
            background-color: transparent;
            box-shadow: 0 4px 15px rgba(0, 91, 153, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .exam-view-form .search-table td {
            padding: 15px 20px;
            vertical-align: middle;
        }
        
        .exam-view-form .search-table .label-cell {
            background-color: #336699;
            color: white;
            font-weight: bold;
            font-size: 18px;
            min-width: 180px;
            text-align: left;
        }
        
        .exam-view-form .search-table .input-cell {
            background-color: white;
            padding: 20px;
        }
        
        .exam-view-form .search-input {
            padding: 12px 15px;
            font-size: 16px;
            border: 2px solid #003366;
            border-radius: 6px;
            background-color: #ffffff;
            color: #333333;
            min-width: 200px;
            font-family: Arial, sans-serif;
            transition: border-color 0.2s ease;
        }
        
        .exam-view-form .search-input:focus {
            outline: none;
            border-color: #0066CC;
            box-shadow: 0 0 5px rgba(0, 102, 204, 0.3);
        }
        
        .exam-view-form .search-input::placeholder {
            color: #999999;
        }
        
        .exam-view-form .button-section {
            text-align: center;
            margin: 25px 0;
        }
        
        .exam-view-form .btn {
            background: linear-gradient(135deg, #005B99, #003366);
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 140px;
            margin: 0 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .exam-view-form .btn:hover {
            background: linear-gradient(135deg, #004070, #002244);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 91, 153, 0.3);
        }
        
        .exam-view-form .btn-secondary {
            background: linear-gradient(135deg, #666666, #444444);
        }
        
        .exam-view-form .btn-secondary:hover {
            background: linear-gradient(135deg, #555555, #333333);
            box-shadow: 0 8px 20px rgba(102, 102, 102, 0.3);
        }
        
        .exam-view-form .btn:focus {
            outline: 3px solid rgba(0, 102, 204, 0.5);
            outline-offset: 2px;
        }
        
        .exam-view-form .btn:active {
            transform: translateY(0);
        }
        
        .exam-view-form .required {
            color: #cc0000;
        }
        
        .exam-view-form .form-hint {
            font-size: 14px;
            color: #666666;
            margin-top: 10px;
            font-style: italic;
            text-align: center;
        }
        
        /* Responsive for this form only */
        @media (max-width: 768px) {
            .exam-view-container {
                padding: 10px;
            }
            
            .exam-view-form {
                width: 95%;
                min-width: auto;
                padding: 25px;
                margin: 20px auto;
            }
            
            .exam-view-form .page-header {
                font-size: 26px;
            }
            
            .exam-view-form .search-table {
                width: 100%;
            }
            
            .exam-view-form .search-table td {
                display: block;
                width: 100%;
                text-align: center;
            }
            
            .exam-view-form .search-table .label-cell {
                border-bottom: none;
                border-radius: 6px 6px 0 0;
            }
            
            .exam-view-form .search-table .input-cell {
                border-radius: 0 0 6px 6px;
            }
            
            .exam-view-form .search-input {
                width: 100%;
                min-width: auto;
            }
            
            .exam-view-form .btn {
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>

    <script>
        function getTs() {
            return new Date().getTime();
        }
        
        window.onload = function() {
            // Focus on the patient ID input for quick entry
            document.getElementById('SysPatientID').focus();
        };
    </script>
</head>
<body>
    <div class="exam-view-container">
        <div class="exam-view-form">
            <div class="page-header">
                Exam View
            </div>
            
            <form method="post" action="entryView.jsp">
                <div class="search-section">
                    <table class="search-table" border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td class="label-cell">
                                    System PatientID
                                </td>
                                <td class="input-cell">
                                    <input type="text" 
                                           name="SysPatientID" 
                                           id="SysPatientID"
                                           class="search-input"
                                           value=""
                                           size="15"
                                           placeholder="Enter Patient ID" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div class="form-hint">
                        Enter the patient ID                  </div>
                </div>

                <div class="button-section">
                    <input type="submit" name="save" value="               SEARCH              " class="btn" />
                </div>
            </form> 

            <form method="post" action="main.do?CheckService=true&CheckMedicalCenter=true&ts="+getTs()>
                <div class="button-section">
                    <input type="submit" name="back" value="                 BACK             " class="btn btn-secondary" />
                </div>
            </form>
        </div>
    </div>


</body>
</html>