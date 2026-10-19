<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>نظام إدارة شؤون الأفراد - الكتيبة 24 مشاة</title>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/localforage/1.10.0/localforage.min.js"></script>
    
    <style>
        :root {
            --primary-dark: #3a4b39;
            --primary-light: #4b6349;
            --accent-green: #27ae60;
            --bg-color: #f0f2f5;
            --card-bg: #ffffff;
            --text-main: #2c3e50;
            --text-muted: #7f8c8d;
            --border-color: #e0e6ed;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Cairo', sans-serif; background-color: var(--bg-color); color: var(--text-main); }
        .hidden { display: none !important; }
        
        #login-screen { display: flex; justify-content: center; align-items: center; height: 100vh; background: linear-gradient(135deg, var(--primary-dark) 0%, #1a2529 100%); }
        .login-box { background: var(--card-bg); padding: 40px 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); width: 380px; text-align: center; }
        .login-box h3 { color: var(--text-muted); font-size: 15px; margin-bottom: 5px; }
        .login-box h2 { color: var(--primary-dark); margin-bottom: 5px; font-weight: 800; }
        .login-box p { color: var(--text-muted); margin-bottom: 20px; font-size: 13px; }
        .login-box input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid var(--border-color); border-radius: 6px; font-family: 'Cairo', sans-serif; outline: none; }
        .btn { background-color: var(--accent-green); color: white; border: none; padding: 10px 15px; border-radius: 6px; cursor: pointer; font-family: 'Cairo', sans-serif; font-weight: bold; font-size: 14px; transition: 0.3s; display: inline-flex; align-items: center; gap: 6px; justify-content: center;}
        .btn:hover { opacity: 0.9; }
        .btn-action { width: auto; padding: 6px 10px; font-size: 13px; margin: 0 2px; }

        .top-header { background-color: var(--primary-dark); color: white; padding: 10px 25px; display: flex; justify-content: space-between; align-items: center; font-size: 14px; }
        .header-title { display: flex; align-items: center; gap: 12px; }
        .header-logo { width: 40px; height: 40px; object-fit: contain; background: transparent; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .user-info .logout-btn { color: #ff6b6b; cursor: pointer; text-decoration: none; }
        .user-info .manage-users-btn { color: #f1c40f; cursor: pointer; text-decoration: none; font-size: 16px; margin-right: 10px; }
        
        .navbar { background-color: var(--card-bg); padding: 0 25px; display: flex; gap: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); overflow-x: auto; }
        .navbar a { color: var(--text-muted); text-decoration: none; cursor: pointer; font-weight: 600; padding: 15px 10px; border-bottom: 3px solid transparent; display: flex; align-items: center; gap: 8px; transition:0.3s;}
        .navbar a:hover, .navbar a.active { color: var(--primary-dark); border-bottom-color: var(--accent-green); }

        .container { padding: 25px; max-width: 1400px; margin: 0 auto; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;}
        .card { background: var(--card-bg); padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        
        .inner-tabs { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 2px solid var(--border-color); padding-bottom: 10px; }
        .inner-tabs button { background: none; border: none; font-family: 'Cairo'; font-weight: bold; font-size: 15px; color: var(--text-muted); cursor: pointer; padding: 5px 15px; border-radius: 6px; transition: 0.3s; }
        .inner-tabs button.active { background: var(--primary-dark); color: white; }

        .autocomplete-wrapper { position: relative; width: 100%; }
        .autocomplete-list { position: absolute; top: 100%; right: 0; width: 100%; background: white; border: 1px solid var(--border-color); border-radius: 6px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-height: 200px; overflow-y: auto; z-index: 1000; list-style: none; padding: 0; margin: 5px 0 0 0; display: none; }
        .autocomplete-list li { padding: 10px; cursor: pointer; border-bottom: 1px solid #eee; font-size: 13px; display: flex; justify-content: space-between; align-items: center;}
        .autocomplete-list li:hover { background-color: #f1f3f5; color: var(--primary-dark); font-weight: bold; }

        .search-box { display: flex; align-items: center; background: white; border: 1px solid var(--border-color); border-radius: 6px; padding: 5px 12px; width: 100%; max-width: 400px; margin-bottom: 10px; }
        .search-box i { color: var(--text-muted); margin-left: 8px; }
        .search-box input { border: none; outline: none; width: 100%; font-family: 'Cairo', sans-serif; font-size: 14px; padding: 5px; }

        .filters-container { display: flex; gap: 15px; margin-bottom: 15px; flex-wrap: wrap; align-items: center; }
        .filter-group { display: flex; align-items: center; background: white; border: 1px solid var(--border-color); border-radius: 6px; overflow: hidden; }
        .filter-group select { border: none; padding: 8px 12px; font-family: 'Cairo', sans-serif; outline: none; font-size: 13px; background: transparent; min-width: 180px; }
        .filter-group button { background: var(--bg-color); border: none; border-right: 1px solid var(--border-color); padding: 8px 12px; cursor: pointer; color: var(--text-muted); transition: 0.3s; }
        .filter-group button:hover { background: var(--border-color); color: var(--primary-dark); }

        .table-responsive { overflow-x: auto; border: 1px solid var(--border-color); border-radius: 8px; padding-bottom: 5px; }
        .table-responsive::-webkit-scrollbar { height: 14px; }
        .table-responsive::-webkit-scrollbar-track { background: #e0e6ed; border-radius: 8px; }
        .table-responsive::-webkit-scrollbar-thumb { background: var(--primary-light); border-radius: 8px; border: 2px solid #e0e6ed; }

        table { width: 100%; border-collapse: collapse; min-width: 800px; }
        th, td { border-bottom: 1px solid var(--border-color); padding: 12px 15px; text-align: right; white-space: nowrap; }
        th { background-color: #f8f9fa; color: var(--text-muted); font-weight: 600; font-size: 14px; }
        tbody tr:hover { background-color: #f1f3f5; }
        
        .sticky-col { position: sticky; left: 0; background-color: white; border-right: 2px solid #ddd; text-align: center; box-shadow: -2px 0 5px rgba(0,0,0,0.05);}
        th.sticky-col { background-color: #e0e6ed; z-index: 2; color: var(--primary-dark); font-weight: bold;}
        tbody tr:hover .sticky-col { background-color: #f1f3f5; }

        .modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: white; padding: 25px; border-radius: 10px; width: 90%; max-width: 900px; max-height: 90vh; overflow-y: auto; }
        .modal-content-small { background: white; padding: 20px; border-radius: 10px; width: 450px; max-height: 80vh; overflow-y: auto; }
        
        .form-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 13px; color: var(--text-muted); margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { padding: 8px; border: 1px solid var(--border-color); border-radius: 4px; font-family: 'Cairo', sans-serif;}
        
        .list-manager-ul { list-style: none; padding: 0; margin: 15px 0; border: 1px solid var(--border-color); border-radius: 6px; }
        .list-manager-ul li { display: flex; justify-content: space-between; align-items: center; padding: 10px; border-bottom: 1px solid var(--border-color); font-size: 14px;}
        .list-manager-ul li:last-child { border-bottom: none; }
        .list-manager-ul button { background: none; border: none; cursor: pointer; font-size: 14px; }
        .list-manager-add { display: flex; gap: 10px; }
        .list-manager-add input { flex-grow: 1; padding: 8px; border: 1px solid var(--border-color); border-radius: 4px; font-family: 'Cairo'; }

        .archive-header-actions { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 15px;}
        .archive-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px; margin-top: 10px; }
        .archive-item { border: 1px solid var(--border-color); border-radius: 8px; padding: 15px; text-align: center; background: #fdfdfd; position: relative; }
        .archive-item h4 { margin-bottom: 10px; color: var(--primary-dark); font-size: 14px; }
        .archive-preview { width: 100%; height: 150px; object-fit: cover; border-radius: 6px; margin-bottom: 10px; background: #eee; display: flex; justify-content: center; align-items: center; color: #aaa; border: 1px dashed #ccc;}
        .archive-actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 8px; }
        .archive-actions button, .archive-actions label { background: var(--bg-color); border: 1px solid #ccc; padding: 5px 8px; border-radius: 4px; cursor: pointer; font-size: 12px; color: #333; transition: 0.3s; display: inline-block;}
        .archive-actions button:hover, .archive-actions label:hover { background: #ddd; }

        /* إخفاء حاويات الطباعة عن العرض العادي */
        #official-print-wrapper, #landscape-print-wrapper { display: none; }

        /* ================== إعدادات الطباعة الأساسية ================== */
        @media print {
            html, body { width: 100% !important; height: 100% !important; margin: 0 !important; padding: 0 !important; background: white !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
            .no-print, #main-app, #login-screen, .modal { display: none !important; }
            
            /* إظهار الحاويات بناءً على فئة الطباعة */
            body.print-portrait #official-print-wrapper { display: block !important; width: 100% !important; }
            body.print-portrait #landscape-print-wrapper { display: none !important; }
            
            body.print-landscape #official-print-wrapper { display: none !important; }
            body.print-landscape #landscape-print-wrapper { display: block !important; width: 100% !important; }

            /* --- تنسيقات الإطار العمودي الافتراضي --- */
            .official-page {
                border: 2px solid #8b0000 !important; border-radius: 10px !important; padding: 6px 6px 1px 6px !important; 
                box-sizing: border-box !important; font-family: 'Cairo', sans-serif !important; width: 100% !important;
                position: relative !important; display: flex !important; flex-direction: column !important;
            }
            body.print-portrait .official-page { min-height: 280mm !important; }
            body.print-landscape .official-page { min-height: 190mm !important; }

            .print-top-box {
                border: 2px solid #8b0000 !important; border-radius: 6px !important; padding: 4px 2px !important;
                background: #fff !important; margin-bottom: 6px !important; box-sizing: border-box !important;
                width: 100% !important; display: table !important; table-layout: fixed !important;
            }
            .print-titles-right { display: table-cell !important; width: 35% !important; vertical-align: middle !important; text-align: right !important; padding-right: 6px !important; }
            .print-titles-right h3 { color: #8b0000 !important; font-size: 14px !important; margin: 0 !important; font-weight: 800 !important; }
            .print-titles-right h4 { font-size: 11px !important; margin: 1px 0 !important; font-weight: 700 !important; color: #111 !important; }
            .print-titles-right h4.green { color: #27ae60 !important; font-weight: 800 !important; }

            .print-logo-center { display: table-cell !important; width: 30% !important; vertical-align: middle !important; text-align: center !important; }
            .print-logo-center img { width: 65px !important; height: 65px !important; object-fit: contain !important; border: none !important; background: transparent !important; display: inline-block !important; }

            .print-meta-left { display: table-cell !important; width: 35% !important; vertical-align: middle !important; text-align: left !important; padding-left: 6px !important; }
            .meta-left-content { display: inline-block !important; text-align: right !important; font-size: 9.5px !important; line-height: 1.6 !important; }

            .print-inner-frame { border: 2px solid #8b0000 !important; border-radius: 8px !important; padding: 8px !important; box-sizing: border-box !important; width: 100% !important; flex-grow: 1 !important; position: relative !important; z-index: 1 !important; margin-bottom: 0 !important; }
            .print-small-box { width: 70px !important; height: 30px !important; border: 1.5px solid #333 !important; border-radius: 3px !important; margin-bottom: 6px !important; float: left !important; }

            .print-watermark {
                position: absolute !important; top: 50% !important; left: 50% !important; transform: translate(-50%, -50%) !important;
                width: 85% !important; max-height: 85% !important; object-fit: contain !important; opacity: 0.1 !important; z-index: 0 !important;
                pointer-events: none !important; mix-blend-mode: multiply !important; 
            }

            .print-content-body { clear: both !important; width: 100% !important; position: relative !important; z-index: 2 !important; }
            .print-footer-text { text-align: left !important; font-size: 9px !important; color: #111 !important; font-weight: bold !important; padding-top: 2px !important; margin-top: 0px !important; padding-left: 8px !important; line-height: 1 !important; }

            .print-table { width: 100% !important; max-width: 100% !important; table-layout: fixed !important; border-collapse: collapse !important; font-size: 8.5pt !important; margin-top: 4px !important; box-sizing: border-box !important; direction: rtl !important; }
            .print-table th, .print-table td { border: 1px solid #333 !important; padding: 4px 2px !important; text-align: center !important; vertical-align: middle !important; word-wrap: break-word !important; overflow-wrap: break-word !important; white-space: normal !important; }
            .print-table th { background-color: #e0e0e0 !important; color: #000 !important; font-weight: bold !important; }
            
            .print-profile-header-images { display: flex !important; justify-content: space-between !important; align-items: flex-start !important; margin-bottom: 15px !important; border-bottom: 2px solid #8b0000 !important; padding-bottom: 10px !important;}
            .print-profile-photo { width: 80px !important; height: 100px !important; border: 1.5px solid #333 !important; padding: 2px !important; background: #fff !important;}
            .print-profile-photo img { width: 100% !important; height: 100% !important; object-fit: cover !important;}
            .print-profile-title { text-align: center !important; font-size: 15px !important; color: #8b0000 !important; font-weight: bold !important; align-self: center !important; flex-grow: 1 !important;}
            
            .print-profile-grid { display: table !important; width: 100% !important; font-size: 10.5pt !important; }
            .print-profile-row { display: table-row !important; }
            .print-profile-item { display: table-cell !important; width: 50% !important; border-bottom: 1px dashed #aaa !important; padding: 6px 2px !important; text-align: right !important; }
            .print-profile-item strong { display: inline-block !important; width: 120px !important; color: #222 !important; }

            /* --- تنسيقات الإطار الأفقي الخاص بكشف الأفراد --- */
            .ls-table { width: 100% !important; border-collapse: collapse !important; margin-top: 10px !important; direction: rtl !important; }
            .ls-table th, .ls-table td { border: 1px solid #333 !important; text-align: center !important; vertical-align: middle !important; padding: 4px 2px !important; }
            .ls-table th { font-weight: bold !important; font-size: 10px !important; background-color: #e0e0e0 !important; color: #000 !important; }
            .ls-table td { font-size: 10px !important; }
            .ls-table th.yellow-bg { background-color: #ffff00 !important; color: #000 !important; font-size: 11px !important;}
        }
    </style>
</head>
<body>

    <!-- شاشة تسجيل الدخول -->
    <div id="login-screen">
        <div class="login-box">
            <div style="margin-bottom: 15px; text-align: center;">
                <img id="login-logo-preview" src="" alt="شعار الكتيبة" style="width: 85px; height: 85px; object-fit: contain; margin: 0 auto 8px auto; display: none; background: transparent;">
                <i id="login-default-icon" class="fa-solid fa-shield-halved" style="font-size: 50px; color: var(--primary-dark); margin-bottom: 15px;"></i>
                <div>
                    <input type="file" id="logo-file-input" accept="image/*" style="display: none;" onchange="uploadLogo(event)">
                    <span style="font-size: 12px; color: #2980b9; cursor: pointer; font-weight: bold;" onclick="document.getElementById('logo-file-input').click()">
                        <i class="fa-solid fa-image"></i> رفع / تغيير الشعار الرسمي
                    </span>
                </div>
            </div>
            <h3>وزارة الدفاع - رئاسة الأركان العامة</h3>
            <h2>الكتيبة 24 مشاة</h2>
            <p>نظام إدارة شؤون الأفراد والضباط</p>
            <input type="text" id="username" placeholder="اسم المستخدم (Admin)">
            <input type="password" id="password" placeholder="كلمة المرور (12345)">
            <button class="btn" style="width: 100%; margin-top: 15px;" onclick="login()">تسجيل الدخول</button>
            <p id="login-error" style="color: #e74c3c; display: none; font-size: 13px; margin-top: 10px; font-weight: bold;">بيانات الدخول غير صحيحة</p>
        </div>
    </div>

    <!-- النظام الأساسي -->
    <div id="main-app" class="hidden">
        <div class="top-header no-print">
            <div class="header-title">
                <img id="header-logo" class="header-logo" src="" alt="شعار" style="display: none;">
                <i class="fa-solid fa-shield-virus" id="header-default-icon"></i>
                <span>وزارة الدفاع | رئاسة الأركان العامة | الكتيبة 24 مشاة</span>
            </div>
            <div class="user-info">
                <a onclick="openUsersManager()" class="manage-users-btn" title="إدارة الحسابات (إضافة/حذف)"><i class="fa-solid fa-user-cog"></i></a>
                <span><i class="fa-regular fa-circle-user"></i> مدير النظام</span>
                <a onclick="logout()" class="logout-btn" title="تسجيل خروج"><i class="fa-solid fa-power-off"></i></a>
            </div>
        </div>

        <div class="navbar no-print">
            <a onclick="showSection('employees')" id="nav-employees" class="active"><i class="fa-solid fa-users"></i> شؤون الأفراد والضباط</a>
            <a onclick="showSection('attendance')" id="nav-attendance"><i class="fa-solid fa-fingerprint"></i> الحضور والانصراف</a>
            <a onclick="showSection('leaves')" id="nav-leaves"><i class="fa-regular fa-calendar-check"></i> الإجازات</a>
            <a onclick="showSection('salary')" id="nav-salary"><i class="fa-solid fa-money-check-dollar"></i> الرواتب</a>
        </div>

        <div class="container">
            <!-- ===================== 1. قسم شؤون الأفراد والضباط ===================== -->
            <div id="employees" class="section">
                <div class="page-header no-print">
                    <h1>شؤون الأفراد والضباط</h1>
                </div>
                
                <div class="card">
                    <!-- تبويبات الضباط / الأفراد -->
                    <div class="inner-tabs no-print">
                        <button id="tab-emp-officers" class="active" onclick="switchEmployeesTab('officers')">الضباط</button>
                        <button id="tab-emp-soldiers" onclick="switchEmployeesTab('soldiers')">الأفراد (السرايا)</button>
                    </div>

                    <!-- أ. قسم إدارة الضباط -->
                    <div id="emp-officers-section">
                        <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 15px;" class="no-print">
                            <button class="btn" style="background-color: #27ae60;" onclick="openAddModal('officer')"><i class="fa-solid fa-user-plus"></i> إضافة ضابط</button>
                            <input type="file" id="excel-file-off" accept=".xlsx, .xls" style="display:none" onchange="importExcel(event)">
                            <button class="btn" style="background-color: #16a085;" onclick="document.getElementById('excel-file-off').click()"><i class="fa-solid fa-file-import"></i> استيراد ضباط</button>
                            <button class="btn" style="background-color: #2980b9;" onclick="exportExcel('officers')"><i class="fa-solid fa-file-export"></i> تصدير إكسيل</button>
                            <button class="btn" style="background-color: var(--primary-dark);" onclick="printAllTable('officers')"><i class="fa-solid fa-print"></i> طباعة كشف الضباط</button>
                        </div>
                        <div class="search-box no-print">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" id="search-input-off" oninput="filterOfficersTable()" placeholder="ابحث في الضباط (الاسم، الرقم، الهاتف)...">
                        </div>
                        <div class="table-responsive">
                            <table style="min-width: 2500px;">
                                <thead><tr id="table-headers-off"></tr></thead>
                                <tbody id="emp-officers-tbody"></tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ب. قسم إدارة الأفراد -->
                    <div id="emp-soldiers-section" class="hidden">
                        <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 15px;" class="no-print">
                            <button class="btn" style="background-color: #27ae60;" onclick="openAddModal('soldier')"><i class="fa-solid fa-user-plus"></i> إضافة فرد</button>
                            <input type="file" id="excel-file-sol" accept=".xlsx, .xls" style="display:none" onchange="importExcel(event)">
                            <button class="btn" style="background-color: #16a085;" onclick="document.getElementById('excel-file-sol').click()"><i class="fa-solid fa-file-import"></i> استيراد أفراد</button>
                            <button class="btn" style="background-color: #2980b9;" onclick="exportExcel('soldiers')"><i class="fa-solid fa-file-export"></i> تصدير إكسيل</button>
                            <button class="btn" style="background-color: var(--primary-dark);" onclick="printAllTable('soldiers')"><i class="fa-solid fa-print"></i> طباعة كشف الأفراد</button>
                        </div>
                        <div class="search-box no-print">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" id="search-input-sol" oninput="filterSoldiersTable()" placeholder="ابحث في الأفراد (الاسم، الرقم، الهاتف)...">
                        </div>
                        <div class="filters-container no-print">
                            <div class="filter-group">
                                <select id="emp-filter-company" onchange="onEmpCompanyFilterChange()"></select>
                                <button onclick="openListManager('companies')" title="إعدادات السرايا"><i class="fa-solid fa-cog"></i></button>
                            </div>
                            <div class="filter-group" id="emp-platoon-filter-container" style="display: none;">
                                <select id="emp-filter-platoon" onchange="filterSoldiersTable()"></select>
                                <button onclick="openListManager('platoons')" title="إعدادات الفصائل"><i class="fa-solid fa-cog"></i></button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table style="min-width: 2500px;">
                                <thead><tr id="table-headers-sol"></tr></thead>
                                <tbody id="emp-soldiers-tbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===================== 2. قسم الحضور والانصراف ===================== -->
            <div id="attendance" class="section hidden">
                <div class="page-header no-print">
                    <h1>الحضور والانصراف</h1>
                </div>
                <div class="card">
                    <div class="inner-tabs no-print">
                        <button id="tab-att-officers" class="active" onclick="switchAttendanceTab('officers')">الضباط</button>
                        <button id="tab-att-soldiers" onclick="switchAttendanceTab('soldiers')">الأفراد (السرايا)</button>
                    </div>

                    <!-- فرعي: قسم الضباط -->
                    <div id="att-officers-section">
                        <div class="inner-tabs no-print" style="border:none; margin-bottom:10px;">
                            <button id="subtab-daily" class="active" onclick="switchOfficersSubTab('daily')">الحضور اليومي</button>
                            <button id="subtab-guard" onclick="switchOfficersSubTab('guard')">جدول الخفارة</button>
                        </div>

                        <!-- الحضور اليومي للضباط -->
                        <div id="daily-attendance-section">
                            <div class="no-print" style="background:#f8f9fa; padding:15px; border-radius:8px; border:1px solid #ddd; margin-bottom:15px;">
                                <h3 style="margin-top:0; color:var(--primary-dark); font-size:15px;">تجهيز كشف الحضور اليومي للضباط</h3>
                                <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end;">
                                    <div class="form-group" style="width:150px;">
                                        <label>التاريخ</label>
                                        <input type="date" id="daily-date" onchange="autoFillDateDay('daily-date', 'daily-day')">
                                    </div>
                                    <div class="form-group" style="width:120px;">
                                        <label>اليوم (تلقائي)</label>
                                        <input type="text" id="daily-day" readonly style="background:#eee; font-weight:bold; color:var(--primary-dark);">
                                    </div>
                                    <div class="form-group">
                                        <button class="btn" style="height:37px;" onclick="printDailyAttendance()"><i class="fa-solid fa-print"></i> طباعة كشف الحضور</button>
                                    </div>
                                </div>
                            </div>
                            <h4 class="no-print" style="margin-bottom:10px; color:var(--primary-dark);">الضباط المدرجين في الكشف حالياً:</h4>
                            <div class="table-responsive no-print">
                                <table style="min-width:100%;">
                                    <thead><tr><th style="width:50px;">ت</th><th>الرتبة</th><th>الإسم</th><th>الرقم العسكري</th></tr></thead>
                                    <tbody id="daily-table-body"></tbody>
                                </table>
                            </div>
                        </div>

                        <!-- جدول الخفارة للضباط -->
                        <div id="guard-duty-section" class="hidden">
                            <div class="no-print" style="background:#f8f9fa; padding:15px; border-radius:8px; border:1px solid #ddd; margin-bottom:15px;">
                                <h3 style="margin-top:0; color:var(--primary-dark); font-size:15px;">إضافة لجدول الخفارة</h3>
                                <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end;">
                                    <div class="form-group" style="width:150px;">
                                        <label>التاريخ</label>
                                        <input type="date" id="guard-date" onchange="autoFillDateDay('guard-date', 'guard-day')">
                                    </div>
                                    <div class="form-group" style="width:120px;">
                                        <label>اليوم (تلقائي)</label>
                                        <input type="text" id="guard-day" readonly style="background:#eee; font-weight:bold; color:var(--primary-dark);">
                                    </div>
                                    <div class="form-group autocomplete-wrapper" style="flex-grow:1; min-width:200px;">
                                        <label>ابحث عن الضابط (الاسم أو الرقم)</label>
                                        <input type="text" id="guard-search-officer" placeholder="اكتب اسم أو رقم الضابط..." onkeyup="searchOfficerForGuard(this.value)" autocomplete="off">
                                        <ul class="autocomplete-list" id="autocomplete-results"></ul>
                                        <input type="hidden" id="guard-mil-id">
                                    </div>
                                    <div class="form-group" style="width:120px;">
                                        <label>الرتبة (تلقائي)</label>
                                        <input type="text" id="guard-rank" readonly style="background:#eee; font-weight:bold; color:var(--primary-dark);">
                                    </div>
                                    <div class="form-group" style="width:200px;">
                                        <label>ملاحظات</label>
                                        <input type="text" id="guard-notes" placeholder="ملاحظات (اختياري)">
                                    </div>
                                    <div class="form-group">
                                        <button class="btn" style="height:37px;" onclick="addGuardRecord()"><i class="fa-solid fa-plus"></i> إدراج للجدول</button>
                                    </div>
                                </div>
                            </div>
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;" class="no-print">
                                <div style="display:flex; gap:10px; align-items:center;">
                                    <label>من تاريخ:</label> <input type="date" id="guard-print-from" class="form-group input" style="padding:4px;">
                                    <label>إلى تاريخ:</label> <input type="date" id="guard-print-to" class="form-group input" style="padding:4px;">
                                </div>
                                <button class="btn" onclick="printGuardSchedule()"><i class="fa-solid fa-print"></i> طباعة جدول الخفارة</button>
                            </div>
                            <div class="table-responsive">
                                <table style="min-width:100%;">
                                    <thead><tr><th style="width:50px;">ت</th><th>التاريخ</th><th>اليوم</th><th>الرتبة</th><th>الإسم</th><th>ملاحظات</th><th class="no-print sticky-col">حذف</th></tr></thead>
                                    <tbody id="guard-table-body"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- فرعي: قسم حضور الأفراد (السرايا) -->
                    <div id="att-soldiers-section" class="hidden">
                        <div class="no-print" style="background:#f8f9fa; padding:15px; border-radius:8px; border:1px solid #ddd; margin-bottom:15px;">
                            <h3 style="margin-top:0; color:var(--primary-dark); font-size:15px; border-bottom:1px solid #ccc; padding-bottom:10px;">تجهيز كشف حضور السرايا (أفقي 15 يوم)</h3>
                            
                            <div style="display:flex; gap:15px; flex-wrap:wrap; margin-bottom:15px;">
                                <div class="form-group" style="min-width:200px;">
                                    <label>اختر السرية</label>
                                    <select id="soldier-att-company" onchange="updateSoldierAttPlatoons()"></select>
                                </div>
                                <div class="form-group" style="min-width:200px;" id="soldier-att-platoon-container">
                                    <label>اختر الفصيل</label>
                                    <select id="soldier-att-platoon" onchange="renderSoldiersAttPreview()"></select>
                                </div>
                            </div>

                            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap:15px; margin-bottom:15px;">
                                <div class="form-group"><label>التاريخ (بداية العمل)</label><input type="date" id="att-start-date" onchange="autoFillDateDay('att-start-date', 'att-start-day')"></div>
                                <div class="form-group"><label>يوم البداية (تلقائي)</label><input type="text" id="att-start-day" readonly style="background:#eee; font-weight:bold; color:var(--primary-dark);"></div>
                                
                                <div class="form-group"><label>التاريخ (نهاية العمل)</label><input type="date" id="att-end-date" onchange="autoFillDateDay('att-end-date', 'att-end-day')"></div>
                                <div class="form-group"><label>يوم النهاية (تلقائي)</label><input type="text" id="att-end-day" readonly style="background:#eee; font-weight:bold; color:var(--primary-dark);"></div>
                                
                                <div class="form-group"><label>تبدأ الإجازة بتاريخ</label><input type="date" id="att-leave-start"></div>
                                <div class="form-group"><label>وتنتهي بتاريخ</label><input type="date" id="att-leave-end"></div>
                            </div>

                            <div style="text-align:left;">
                                <button class="btn" onclick="printSoldiersAttendance()"><i class="fa-solid fa-print"></i> طباعة كشف حضور الأفراد (أفقي)</button>
                            </div>
                        </div>

                        <h4 class="no-print" style="margin-bottom:10px; color:var(--primary-dark);">الأفراد الذين سيتم طباعة الكشف لهم:</h4>
                        <div class="table-responsive no-print">
                            <table style="min-width:100%;">
                                <thead><tr><th style="width:50px;">ت</th><th>الرقم العسكري</th><th>الإسم</th><th>السرية / الفصيل</th></tr></thead>
                                <tbody id="soldiers-att-preview-body"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div id="leaves" class="section hidden"><div class="page-header"><h1>الإجازات</h1></div></div>
            <div id="salary" class="section hidden"><div class="page-header"><h1>الرواتب</h1></div></div>
        </div>
    </div>

    <!-- النوافذ المنبثقة -->
    <div id="form-modal" class="modal hidden no-print">
        <div class="modal-content">
            <h2 id="modal-title" style="color: var(--primary-dark); border-bottom: 2px solid var(--border-color); padding-bottom: 10px;">إضافة جديد</h2>
            <div class="form-grid" id="dynamic-form-inputs"></div>
            <div style="display: flex; gap: 10px; margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 15px;">
                <button class="btn" style="background-color: var(--accent-green);" onclick="saveFormRecord()">حفظ البيانات</button>
                <button class="btn" style="background-color: #e74c3c;" onclick="closeModal('form-modal')">إلغاء</button>
            </div>
        </div>
    </div>

    <div id="archive-modal" class="modal hidden no-print">
        <div class="modal-content" style="background-color: #f4f6f9;">
            <div class="archive-header-actions">
                <h2 id="archive-modal-title" style="color: var(--primary-dark); margin:0;">الأرشيف الإلكتروني</h2>
                <button class="btn" style="background-color: #8e44ad;" onclick="addNewArchiveSlot()"><i class="fa-solid fa-plus"></i> إضافة مستند جديد </button>
            </div>
            <p style="font-size:13px; color:#e74c3c; margin-top:5px; font-weight:bold;"><i class="fa-solid fa-info-circle"></i> تنويه: يتم ضغط الصور لحفظ مساحة النظام. ملفات الـ PDF تُحفظ بجودتها ويمكن فتحها.</p>
            <div class="archive-grid" id="archive-grid-container"></div>
            <div style="text-align: left; margin-top: 20px; border-top: 1px solid #ccc; padding-top: 15px;">
                <button class="btn" style="background-color: var(--primary-dark);" onclick="closeModal('archive-modal')">إغلاق الأرشيف</button>
            </div>
        </div>
    </div>

    <div id="list-manager-modal" class="modal hidden no-print">
        <div class="modal-content-small">
            <h3 id="list-modal-title" style="color: var(--primary-dark); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 15px;">إدارة القائمة</h3>
            <div class="list-manager-add">
                <input type="text" id="new-list-item" placeholder="أدخل اسماً جديداً...">
                <button class="btn" onclick="addListItem()" style="width: auto;">إضافة</button>
            </div>
            <ul class="list-manager-ul" id="list-manager-items"></ul>
            <div style="text-align: left; margin-top: 15px;">
                <button class="btn" style="background-color: var(--primary-dark); width: 100%;" onclick="closeModal('list-manager-modal')">إغلاق وتحديث</button>
            </div>
        </div>
    </div>

    <div id="users-manager-modal" class="modal hidden no-print">
        <div class="modal-content-small">
            <h3 style="color: var(--primary-dark); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 15px;">إدارة حسابات الدخول</h3>
            <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                <input type="text" id="new-username" placeholder="اسم المستخدم" style="flex:1; padding: 8px; border: 1px solid var(--border-color); border-radius: 4px; font-family: 'Cairo';">
                <input type="text" id="new-password" placeholder="كلمة المرور" style="flex:1; padding: 8px; border: 1px solid var(--border-color); border-radius: 4px; font-family: 'Cairo';">
            </div>
            <button class="btn" onclick="addUser()" style="width: 100%; margin-bottom: 15px; background-color: var(--accent-green);">إضافة حساب جديد</button>
            <ul class="list-manager-ul" id="users-list-items"></ul>
            <div style="text-align: left; margin-top: 15px;">
                <button class="btn" style="background-color: var(--primary-dark); width: 100%;" onclick="closeModal('users-manager-modal')">إغلاق</button>
            </div>
        </div>
    </div>

    <!-- ================== حاويات الطباعة الموحدة ================== -->
    
    <!-- 1. نموذج الطباعة العمودي -->
    <div id="official-print-wrapper">
        <div class="official-page">
            <div class="print-top-box" id="print-top-box">
                <div class="print-titles-right">
                    <h3>وزارة الدفاع</h3>
                    <h4>رئاسة الأركان العامة</h4>
                    <h4 class="green">الكتيبة 24 مشاة</h4>
                </div>
                <div class="print-logo-center"><img id="print-frame-logo" src="" alt="شعار"></div>
                <div class="print-meta-left"><div class="meta-left-content" id="print-meta-content"></div></div>
            </div>
            <div class="print-inner-frame">
                <div class="print-small-box" id="print-small-box"></div>
                <img class="print-watermark" id="print-watermark-img" src="" alt="">
                <div class="print-content-body" id="print-content-slot"></div>
            </div>
            <div class="print-footer-text">إدارة المطابع العسكرية</div>
        </div>
    </div>

    <!-- 2. نموذج الطباعة الأفقي -->
    <div id="landscape-print-wrapper">
        <div class="official-page">
            <div class="print-top-box" style="display:flex !important; justify-content:space-between; align-items:center;">
                <div class="print-titles-right" style="width:30% !important; text-align:right !important;">
                    <h3>وزارة الدفاع</h3>
                    <h4>رئاسة الأركان العامة</h4>
                    <h4 class="green">الكتيبة 24 مشاة</h4>
                </div>
                <div class="print-logo-center" style="width:40% !important; text-align:center !important;">
                    <img id="print-frame-logo-ls" src="" alt="شعار">
                </div>
                <div class="print-meta-left" style="width:30% !important; text-align:left !important;">
                    <div class="meta-left-content" id="landscape-meta-content"></div>
                </div>
            </div>
            <div class="print-inner-frame">
                <img class="print-watermark" id="print-watermark-img-ls" src="" alt="">
                <div class="print-content-body" id="landscape-print-slot"></div>
            </div>
            <div class="print-footer-text">إدارة المطابع العسكرية</div>
        </div>
    </div>

    <script>
        const fields = [
            { key: 'mil_id', label: 'الرقم العسكري' }, { key: 'rank', label: 'الرتبة' }, { key: 'name', label: 'الإسم الرباعي' },
            { key: 'company', label: 'السرية / القسم' }, { key: 'platoon', label: 'الفصيل' }, { key: 'mother', label: 'إسم الأم' },
            { key: 'dob', label: 'تاريخ الميلاد' }, { key: 'id_card', label: 'رقم البطاقة الشخصية' }, { key: 'gender', label: 'الجنس' },
            { key: 'nationality', label: 'الجنسية' }, { key: 'status', label: 'الحالة الاجتماعية' }, { key: 'children', label: 'عدد الأبناء' },
            { key: 'family_book', label: 'رقم ورقة العائلة' }, { key: 'passport', label: 'رقم جواز السفر' }, { key: 'address', label: 'عنوان السكن' },
            { key: 'phone', label: 'رقم الهاتف' }, { key: 'education', label: 'المؤهل العلمي' }, { key: 'recruit_type', label: 'صفة التجنيد' },
            { key: 'join_date', label: 'تاريخ الإلتحاق' }, { key: 'bank', label: 'إسم المصرف' }, { key: 'acc_num', label: 'رقم الحساب' },
            { key: 'nat_id', label: 'الرقم الوطني' }, { key: 'reg_num', label: 'رقم القيد' }
        ];

        let db = { employees: [], companies: [], platoons: [], users: [], officers_guard: [] };
        let activeOfficersData = []; let activeSoldiersData = [];
        let mode = 'add'; let currentEditingMilId = null; let currentArchiveMilId = null; let managingListType = ''; let isDbLoaded = false;

        function saveDB() { localforage.setItem('military_db_v5', JSON.stringify(db)).catch(err => console.error(err)); }

        function normalizeArchiveStructure(emp) {
            if (!emp.archive || !Array.isArray(emp.archive)) {
                let oldArchive = emp.archive || {};
                emp.archive = [
                    { id: '1', title: 'صورة عسكرية (1)', data: oldArchive['1'] || null, isFixed: true },
                    { id: '2', title: 'صورة مدنية (2)', data: oldArchive['2'] || null, isFixed: true },
                    { id: '3', title: 'شهادة ميلاد (3)', data: oldArchive['3'] || null, isFixed: true }
                ];
                for(let key in oldArchive) { if(key !== '1' && key !== '2' && key !== '3' && key !== 'other') { if(oldArchive[key]) emp.archive.push({ id: key, title: 'مستند إضافي', data: oldArchive[key], isFixed: false }); } }
            }
        }

        function loadDB() {
            localforage.getItem('military_db_v5').then(function(savedDB) {
                if (savedDB) {
                    db = JSON.parse(savedDB);
                    if(!db.users || db.users.length === 0) { db.users = [{ username: 'Admin', password: '12345' }]; }
                    if(!db.officers_guard) { db.officers_guard = []; }
                    db.employees.forEach(emp => normalizeArchiveStructure(emp));
                    saveDB();
                } else {
                    db.companies = ['الضباط', 'السرية الأولى', 'السرية الثانية', 'السرية الثالثة', 'سرية المطار'];
                    db.platoons = ['الفصيل الأول', 'الفصيل الثاني', 'الفصيل الثالث', 'الفصيل الرابع'];
                    db.users = [{ username: 'Admin', password: '12345' }]; db.officers_guard = [];
                    db.employees = [
                        { mil_id: '10001', rank: 'عريف', name: 'أحمد محمود علي العبدلي', company: 'السرية الأولى', platoon: 'الفصيل الأول', archive: [], mother: 'فاطمة سالم', dob: '1995-05-14', id_card: '123456', gender: 'ذكر', nationality: 'ليبي', status: 'أعزب', children: '0', family_book: '-', passport: 'P1234567', address: 'طرابلس', phone: '0911234567', education: 'ثانوية عامة', recruit_type: 'تطوع', join_date: '2015-02-01', bank: 'الجمهورية', acc_num: '100200300400', nat_id: '119950123456', reg_num: '5544' },
                        { mil_id: '10005', rank: 'نقيب', name: 'عبدالمجيد حسين التركي', company: 'الضباط', platoon: '', archive: [], mother: '', dob: '', id_card: '', gender: 'ذكر', nationality: 'ليبي', status: '', children: '', family_book: '', passport: '', address: '', phone: '', education: '', recruit_type: '', join_date: '', bank: '', acc_num: '', nat_id: '', reg_num: '' }
                    ];
                    db.employees.forEach(emp => normalizeArchiveStructure(emp)); saveDB();
                }
                isDbLoaded = true; updateFilterDropdowns(); filterOfficersTable(); filterSoldiersTable(); renderGuardTable(); renderDailyOfficersTable(); initSoldiersAttUI();
            }).catch(function(err) { console.error(err); });
        }

        window.addEventListener('DOMContentLoaded', () => {
            loadDB(); 
            const savedLogo = localStorage.getItem('battalion_logo'); if (savedLogo) { updateLogoUI(savedLogo); }
            renderTableHeaders();
            document.addEventListener('click', function(e) { if(!e.target.closest('.autocomplete-wrapper')) { document.getElementById('autocomplete-results').style.display = 'none'; } });
        });

        // ------------------ دالة إجبار الطباعة الموثوقة ------------------
        function setPrintOrientation(mode) {
            let style = document.getElementById('dynamic-print-style');
            if (!style) { style = document.createElement('style'); style.id = 'dynamic-print-style'; document.head.appendChild(style); }
            document.body.classList.remove('print-portrait', 'print-landscape');
            if (mode === 'landscape') {
                document.body.classList.add('print-landscape');
                style.innerHTML = `@media print { @page { size: A4 landscape !important; margin: 5mm !important; } }`;
            } else {
                document.body.classList.add('print-portrait');
                style.innerHTML = `@media print { @page { size: A4 portrait !important; margin: 4mm !important; } }`;
            }
        }

        function autoFillDateDay(dateInputId, dayInputId) {
            const dateVal = document.getElementById(dateInputId).value; const dayInput = document.getElementById(dayInputId);
            if(!dateVal) { dayInput.value = ''; return; }
            const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
            const d = new Date(dateVal); dayInput.value = days[d.getDay()];
        }

        function openBase64InNewTab(dataUrl, titleStr) {
            try {
                let parts = dataUrl.split(';base64,'); let contentType = parts[0].split(':')[1];
                let raw = window.atob(parts[1]); let rawLength = raw.length; let uInt8Array = new Uint8Array(rawLength);
                for (let i = 0; i < rawLength; ++i) { uInt8Array[i] = raw.charCodeAt(i); }
                let blob = new Blob([uInt8Array], { type: contentType }); let blobUrl = URL.createObjectURL(blob);
                window.open(blobUrl, '_blank');
            } catch (error) { alert("حدث خطأ أثناء الفتح."); console.error(error); }
        }

        function login() {
            if(!isDbLoaded) return alert("جاري تحميل قاعدة البيانات...");
            const user = document.getElementById('username').value.trim(); const pass = document.getElementById('password').value.trim();
            const validUser = db.users.find(u => u.username.toLowerCase() === user.toLowerCase() && u.password === pass);
            if(validUser) {
                document.getElementById('login-screen').classList.add('hidden'); document.getElementById('main-app').classList.remove('hidden');
                buildFormInputs(); filterOfficersTable(); filterSoldiersTable();
            } else { document.getElementById('login-error').style.display = 'block'; }
        }
        function logout() { location.reload(); }

        function openUsersManager() { document.getElementById('new-username').value = ''; document.getElementById('new-password').value = ''; renderUsersList(); document.getElementById('users-manager-modal').classList.remove('hidden'); }
        function renderUsersList() {
            const ul = document.getElementById('users-list-items'); ul.innerHTML = '';
            db.users.forEach((u, index) => {
                const deleteBtn = u.username.toLowerCase() === 'admin' ? `<span style="color:#7f8c8d; font-size:11px;">أساسي</span>` : `<button style="color: #e74c3c;" onclick="deleteUser(${index})" title="حذف החساب"><i class="fa-solid fa-trash"></i></button>`;
                ul.innerHTML += `<li><span><i class="fa-solid fa-user"></i> ${u.username}</span><div>${deleteBtn}</div></li>`;
            });
        }
        function addUser() {
            const username = document.getElementById('new-username').value.trim(); const password = document.getElementById('new-password').value.trim();
            if(!username || !password) return alert('إدخال مطلوب!');
            if(db.users.some(u => u.username.toLowerCase() === username.toLowerCase())) return alert('موجود مسبقاً!');
            db.users.push({ username, password }); saveDB(); document.getElementById('new-username').value = ''; document.getElementById('new-password').value = ''; renderUsersList();
        }
        function deleteUser(index) {
            if(db.users[index].username.toLowerCase() === 'admin') return alert('ممنوع!');
            if(confirm('متأكد من الحذف؟')) { db.users.splice(index, 1); saveDB(); renderUsersList(); }
        }

        function uploadLogo(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) { const base64Image = e.target.result; localStorage.setItem('battalion_logo', base64Image); updateLogoUI(base64Image); alert('تم التحديث بنجاح!'); };
                reader.readAsDataURL(file);
            }
        }
        function updateLogoUI(src) {
            const loginPreview = document.getElementById('login-logo-preview'); const loginIcon = document.getElementById('login-default-icon');
            if (loginPreview && loginIcon) { loginPreview.src = src; loginPreview.style.display = 'block'; loginIcon.style.display = 'none'; }
            const headerLogo = document.getElementById('header-logo'); const headerIcon = document.getElementById('header-default-icon');
            if (headerLogo && headerIcon) { headerLogo.src = src; headerLogo.style.display = 'block'; headerIcon.style.display = 'none'; }
            const printLogo = document.getElementById('print-frame-logo'); if (printLogo) { printLogo.src = src; }
            const printWatermarkImg = document.getElementById('print-watermark-img'); if (printWatermarkImg) { printWatermarkImg.src = src; }
            const printLogoLs = document.getElementById('print-frame-logo-ls'); if (printLogoLs) { printLogoLs.src = src; }
            const printWatermarkImgLs = document.getElementById('print-watermark-img-ls'); if (printWatermarkImgLs) { printWatermarkImgLs.src = src; }
        }
        function showSection(sectionId) {
            document.querySelectorAll('.section').forEach(sec => sec.classList.add('hidden')); document.getElementById(sectionId).classList.remove('hidden');
            document.querySelectorAll('.navbar a').forEach(link => link.classList.remove('active')); document.getElementById('nav-' + sectionId).classList.add('active');
        }

        // ================== شؤون الأفراد والضباط المُقسّم ==================
        function switchEmployeesTab(tab) {
            document.getElementById('tab-emp-officers').classList.remove('active'); document.getElementById('tab-emp-soldiers').classList.remove('active');
            document.getElementById('emp-officers-section').classList.add('hidden'); document.getElementById('emp-soldiers-section').classList.add('hidden');
            document.getElementById('tab-emp-' + tab).classList.add('active'); document.getElementById('emp-' + tab + '-section').classList.remove('hidden');
        }

        function renderTableHeaders() {
            const trOff = document.getElementById('table-headers-off'); trOff.innerHTML = '';
            const trSol = document.getElementById('table-headers-sol'); trSol.innerHTML = '';
            fields.forEach(f => { 
                let thOff = document.createElement('th'); thOff.innerText = f.label; trOff.appendChild(thOff); 
                let thSol = document.createElement('th'); thSol.innerText = f.label; trSol.appendChild(thSol); 
            });
            let actionThOff = document.createElement('th'); actionThOff.className = 'no-print sticky-col'; actionThOff.innerText = 'الإجراءات'; trOff.appendChild(actionThOff);
            let actionThSol = document.createElement('th'); actionThSol.className = 'no-print sticky-col'; actionThSol.innerText = 'الإجراءات'; trSol.appendChild(actionThSol);
        }

        function renderEmployeeTable(data, tbodyId) {
            const tbody = document.getElementById(tbodyId); tbody.innerHTML = '';
            data.forEach(emp => {
                let tr = document.createElement('tr');
                fields.forEach(f => {
                    let td = document.createElement('td');
                    if (f.key === 'mil_id' || f.key === 'name') td.innerHTML = `<strong>${emp[f.key] || ''}</strong>`; else td.innerText = emp[f.key] || '';
                    tr.appendChild(td);
                });
                let actionTd = document.createElement('td'); actionTd.className = 'no-print sticky-col';
                actionTd.innerHTML = `
                    <button class="btn btn-action" style="background:#9b59b6;" onclick="openArchiveModal('${emp.mil_id}')" title="الأرشيف الإلكتروني"><i class="fa-solid fa-folder-open"></i></button>
                    <button class="btn btn-action" style="background:#3498db;" onclick="printIndividual('${emp.mil_id}')" title="طباعة الفرد"><i class="fa-solid fa-print"></i></button>
                    <button class="btn btn-action" style="background:#f39c12;" onclick="openEditModal('${emp.mil_id}')" title="تعديل"><i class="fa-solid fa-pen"></i></button>
                    <button class="btn btn-action" style="background:#e74c3c;" onclick="deleteEmployee('${emp.mil_id}')" title="حذف"><i class="fa-solid fa-trash"></i></button>
                `;
                tr.appendChild(actionTd); tbody.appendChild(tr);
            });
        }

        function filterOfficersTable() {
            const query = document.getElementById('search-input-off').value.toLowerCase().trim();
            activeOfficersData = db.employees.filter(e => {
                let isOff = e.company === 'الضباط';
                let matchesSearch = fields.some(f => String(e[f.key] || '').toLowerCase().includes(query));
                return isOff && matchesSearch;
            });
            renderEmployeeTable(activeOfficersData, 'emp-officers-tbody');
        }

        function filterSoldiersTable() {
            const query = document.getElementById('search-input-sol').value.toLowerCase().trim();
            const fComp = document.getElementById('emp-filter-company').value;
            const fPlat = document.getElementById('emp-filter-platoon').value;
            activeSoldiersData = db.employees.filter(e => {
                let isSol = e.company !== 'الضباط';
                let matchesSearch = fields.some(f => String(e[f.key] || '').toLowerCase().includes(query));
                let matchesComp = (fComp === '') || (e.company === fComp);
                let matchesPlat = (fPlat === '') || (e.platoon === fPlat);
                return isSol && matchesSearch && matchesComp && matchesPlat;
            });
            renderEmployeeTable(activeSoldiersData, 'emp-soldiers-tbody');
        }

        function updateFilterDropdowns() {
            const compSelect = document.getElementById('emp-filter-company'); compSelect.innerHTML = `<option value="">-- كل السرايا --</option>`; 
            db.companies.forEach(c => { if(c !== 'الضباط') compSelect.innerHTML += `<option value="${c}">${c}</option>`; });
            
            const platSelect = document.getElementById('emp-filter-platoon'); platSelect.innerHTML = `<option value="">-- كل الفصائل --</option>`; 
            db.platoons.forEach(p => platSelect.innerHTML += `<option value="${p}">${p}</option>`);

            initSoldiersAttUI(); 
        }

        function onEmpCompanyFilterChange() {
            const comp = document.getElementById('emp-filter-company').value; const platContainer = document.getElementById('emp-platoon-filter-container');
            if(comp && comp !== '') { platContainer.style.display = 'flex'; } else { platContainer.style.display = 'none'; document.getElementById('emp-filter-platoon').value = ''; }
            filterSoldiersTable();
        }

        function buildFormInputs() {
            const container = document.getElementById('dynamic-form-inputs'); container.innerHTML = '';
            fields.forEach(f => {
                let inputHTML = '';
                if(f.key === 'company') {
                    inputHTML = `<select id="inp-${f.key}"><option value="">-- اختر السرية / القسم --</option>`; db.companies.forEach(c => inputHTML += `<option value="${c}">${c}</option>`); inputHTML += `</select>`;
                } else if(f.key === 'platoon') {
                    inputHTML = `<select id="inp-${f.key}"><option value="">-- بدون فصيل --</option>`; db.platoons.forEach(p => inputHTML += `<option value="${p}">${p}</option>`); inputHTML += `</select>`;
                } else { inputHTML = `<input type="text" id="inp-${f.key}" placeholder="أدخل ${f.label}">`; }
                container.innerHTML += `<div class="form-group"><label>${f.label}</label>${inputHTML}</div>`;
            });
        }

        function openAddModal(type) {
            mode = 'add'; currentEditingMilId = null; 
            document.getElementById('modal-title').innerText = type === 'officer' ? 'إضافة ضابط جديد' : 'إضافة فرد جديد';
            fields.forEach(f => { document.getElementById(`inp-${f.key}`).value = ''; }); 
            if(type === 'officer') { document.getElementById('inp-company').value = 'الضباط'; }
            document.getElementById('form-modal').classList.remove('hidden');
        }
        function openEditModal(milId) {
            mode = 'edit'; currentEditingMilId = milId; document.getElementById('modal-title').innerText = 'تعديل بيانات الفرد/الضابط';
            const emp = db.employees.find(e => e.mil_id === milId); if(!emp) return;
            fields.forEach(f => { document.getElementById(`inp-${f.key}`).value = emp[f.key] || ''; }); document.getElementById('form-modal').classList.remove('hidden');
        }
        function saveFormRecord() {
            let formData = {}; fields.forEach(f => { formData[f.key] = document.getElementById(`inp-${f.key}`).value.trim(); });
            if(!formData.mil_id || !formData.name) return alert('الرقم العسكري والإسم الرباعي أساسية!');
            if (mode === 'add') {
                if (db.employees.some(e => e.mil_id === formData.mil_id || e.name === formData.name)) return alert('الرقم أو الاسم مكرر!');
                normalizeArchiveStructure(formData); db.employees.push(formData);
            } else {
                if (db.employees.some(e => (e.mil_id === formData.mil_id || e.name === formData.name) && e.mil_id !== currentEditingMilId)) return alert('الرقم أو الاسم مكرر!');
                let index = db.employees.findIndex(e => e.mil_id === currentEditingMilId);
                if (index > -1) { formData.archive = db.employees[index].archive; db.employees[index] = formData; }
            }
            saveDB(); filterOfficersTable(); filterSoldiersTable(); renderDailyOfficersTable(); renderSoldiersAttPreview(); closeModal('form-modal');
        }
        function deleteEmployee(milId) {
            if(confirm('متأكد من الحذف نهائياً؟')) { db.employees = db.employees.filter(e => e.mil_id !== milId); saveDB(); filterOfficersTable(); filterSoldiersTable(); renderDailyOfficersTable(); renderSoldiersAttPreview(); }
        }

        function exportExcel(type) {
            let dataToExport = type === 'officers' ? activeOfficersData : activeSoldiersData;
            let title = type === 'officers' ? "كشف_الضباط" : "كشف_الأفراد";
            let exportData = dataToExport.map(emp => { let row = {}; fields.forEach(f => { row[f.label] = emp[f.key]; }); return row; });
            const worksheet = XLSX.utils.json_to_sheet(exportData); const workbook = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(workbook, worksheet, "البيانات"); XLSX.writeFile(workbook, `${title}.xlsx`);
        }
        function importExcel(event) {
            const file = event.target.files[0]; if(!file) return; const reader = new FileReader();
            reader.onload = function(e) {
                const data = new Uint8Array(e.target.result); const workbook = XLSX.read(data, {type: 'array'});
                const excelData = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
                if(excelData.length > 0) {
                    let newEmployees = [];
                    excelData.forEach(row => {
                        let newEmp = {}; fields.forEach(f => { newEmp[f.key] = row[f.label] !== undefined ? String(row[f.label]) : ''; });
                        normalizeArchiveStructure(newEmp); newEmployees.push(newEmp);
                    });
                    db.employees = newEmployees; saveDB(); filterOfficersTable(); filterSoldiersTable(); renderDailyOfficersTable(); renderSoldiersAttPreview(); alert("تم استيراد بيانات الإكسيل بنجاح!");
                }
            }; reader.readAsArrayBuffer(file); event.target.value = '';
        }

        // ================== الحضور والانصراف ==================
        function switchAttendanceTab(tab) {
            document.getElementById('tab-att-officers').classList.remove('active'); document.getElementById('tab-att-soldiers').classList.remove('active');
            document.getElementById('att-officers-section').classList.add('hidden'); document.getElementById('att-soldiers-section').classList.add('hidden');
            document.getElementById('tab-att-' + tab).classList.add('active'); document.getElementById('att-' + tab + '-section').classList.remove('hidden');
            if(tab === 'soldiers') { renderSoldiersAttPreview(); }
        }
        function switchOfficersSubTab(subTab) {
            document.getElementById('subtab-daily').classList.remove('active'); document.getElementById('subtab-guard').classList.remove('active');
            document.getElementById('daily-attendance-section').classList.add('hidden'); document.getElementById('guard-duty-section').classList.add('hidden');
            document.getElementById('subtab-' + subTab).classList.add('active');
            if(subTab === 'daily') { document.getElementById('daily-attendance-section').classList.remove('hidden'); } else { document.getElementById('guard-duty-section').classList.remove('hidden'); }
        }

        function renderDailyOfficersTable() {
            const tbody = document.getElementById('daily-table-body'); tbody.innerHTML = '';
            const officers = db.employees.filter(e => e.company === 'الضباط');
            if(officers.length === 0) { tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;">لا يوجد ضباط.</td></tr>`; return; }
            officers.forEach((off, idx) => { tbody.innerHTML += `<tr><td>${idx + 1}</td><td>${off.rank}</td><td><strong>${off.name}</strong></td><td>${off.mil_id}</td></tr>`; });
        }
        
        function printDailyAttendance() {
            setPrintOrientation('portrait'); 
            const dateVal = document.getElementById('daily-date').value; const dayVal = document.getElementById('daily-day').value;
            if(!dateVal) return alert("الرجاء تحديد التاريخ أولاً!");
            const officers = db.employees.filter(e => e.company === 'الضباط');
            if(officers.length === 0) return alert("لا يوجد ضباط للطباعة.");

            setupOfficialPrintTemplate('', true); 
            const printSlot = document.getElementById('print-content-slot');
            let html = `
                <div style="text-align: center; margin-bottom: 15px;">
                    <h3 style="font-size: 15px; font-weight: bold; color: #111; margin-bottom:5px;">جدول الحضور للضباط الكتيبة 24 مشاة</h3>
                    <h4 style="font-size: 13px; color:#2980b9; margin:0;">ليوم ${dayVal} الموافق ${dateVal}</h4>
                </div>
                <table class="print-table" style="font-size: 12px;">
                    <thead><tr><th style="width: 8%;">تسلسل</th><th style="width: 15%;">الرتبة</th><th style="width: 35%;">الاسم</th><th style="width: 20%;">التوقيع</th><th style="width: 22%;">ملاحظات</th></tr></thead>
                    <tbody>
            `;
            officers.forEach((r, idx) => { html += `<tr><td>${idx + 1}</td><td>${r.rank}</td><td style="font-weight:bold;">${r.name}</td><td></td><td></td></tr>`; });
            html += `</tbody></table>
                <div style="margin-top: 30px; font-size: 12px;">
                    <p style="font-weight:bold; margin-bottom:40px;">ملاحظة // على جميع الضباط تعبئة سجل الحضور وتسليمه يوميا إلى أمر المعسكر</p>
                    <div style="text-align: right; margin-right:50px;"><strong style="font-size:14px;">اعتماد مساعد آمر الكتيبة</strong></div>
                </div>`;
            printSlot.innerHTML = html; 
            setTimeout(() => window.print(), 150); // تأخير بسيط لضمان تحديث DOM
        }

        function searchOfficerForGuard(query) {
            const resultList = document.getElementById('autocomplete-results'); resultList.innerHTML = '';
            query = query.trim(); if(query.length === 0) { resultList.style.display = 'none'; return; }
            const matched = db.employees.filter(e => (e.company === 'الضباط') && (e.name.includes(query) || String(e.mil_id).includes(query)));
            if(matched.length === 0) { resultList.style.display = 'none'; return; }
            matched.forEach(off => {
                let li = document.createElement('li');
                li.innerHTML = `<span>${off.name}</span> <span style="color:#7f8c8d; font-size:11px;">(${off.rank}) - ${off.mil_id}</span>`;
                li.onclick = () => { document.getElementById('guard-search-officer').value = off.name; document.getElementById('guard-rank').value = off.rank; document.getElementById('guard-mil-id').value = off.mil_id; resultList.style.display = 'none'; };
                resultList.appendChild(li);
            });
            resultList.style.display = 'block';
        }
        function addGuardRecord() {
            const date = document.getElementById('guard-date').value; const day = document.getElementById('guard-day').value;
            const name = document.getElementById('guard-search-officer').value.trim(); const rank = document.getElementById('guard-rank').value;
            const mil_id = document.getElementById('guard-mil-id').value; const notes = document.getElementById('guard-notes').value.trim();
            if(!date || !name || !rank) return alert('تأكد من إدخال التاريخ واختيار الضابط.');
            db.officers_guard.push({ id: Date.now().toString(), date: date, day: day, name: name, rank: rank, mil_id: mil_id, notes: notes });
            db.officers_guard.sort((a, b) => new Date(a.date) - new Date(b.date)); saveDB(); renderGuardTable();
            document.getElementById('guard-search-officer').value = ''; document.getElementById('guard-rank').value = '';
            document.getElementById('guard-mil-id').value = ''; document.getElementById('guard-notes').value = '';
            document.getElementById('guard-search-officer').focus();
        }
        function renderGuardTable() {
            const tbody = document.getElementById('guard-table-body'); tbody.innerHTML = '';
            db.officers_guard.forEach((record, index) => {
                let tr = document.createElement('tr');
                tr.innerHTML = `<td><strong>${index + 1}</strong></td><td>${record.date}</td><td style="color:var(--primary-dark); font-weight:bold;">${record.day}</td>
                    <td>${record.rank}</td><td><strong>${record.name}</strong></td><td>${record.notes}</td>
                    <td class="no-print sticky-col"><button class="btn-action" style="background:#e74c3c; color:white; border:none; border-radius:4px; padding:4px 8px; cursor:pointer;" onclick="deleteGuardRecord('${record.id}')"><i class="fa-solid fa-times"></i></button></td>`;
                tbody.appendChild(tr);
            });
        }
        function deleteGuardRecord(id) { db.officers_guard = db.officers_guard.filter(r => r.id !== id); saveDB(); renderGuardTable(); }
        
        function printGuardSchedule() {
            setPrintOrientation('portrait'); 
            const printFrom = document.getElementById('guard-print-from').value; const printTo = document.getElementById('guard-print-to').value;
            let subtitle = ""; if(printFrom && printTo) subtitle = `من تاريخ ${printFrom} إلى تاريخ ${printTo}`;
            setupOfficialPrintTemplate('', true); 
            const printSlot = document.getElementById('print-content-slot');
            let html = `
                <div style="text-align: center; margin-bottom: 15px;">
                    <h3 style="font-size: 15px; font-weight: bold; color: #111; margin-bottom:5px;">جدول خفارة ضباط الخفر بوحدتنا الكتيبة 24 مشاة</h3>
                    <h4 style="font-size: 13px; color:#2980b9; margin:0;">${subtitle}</h4>
                </div>
                <table class="print-table" style="font-size: 12px;">
                    <thead><tr><th style="width: 8%;">ت</th><th style="width: 17%;">التاريخ</th><th style="width: 15%;">اليوم</th><th style="width: 15%;">الرتبة</th><th style="width: 25%;">الإسم</th><th style="width: 20%;">ملاحظات</th></tr></thead>
                    <tbody>
            `;
            let recordsToPrint = db.officers_guard;
            if(printFrom && printTo) { recordsToPrint = db.officers_guard.filter(r => r.date >= printFrom && r.date <= printTo); }
            recordsToPrint.forEach((r, idx) => {
                let dayColor = '#000'; if(r.day === 'الجمعة' || r.day === 'السبت' || r.day === 'الأحد') dayColor = '#c0392b';
                html += `<tr><td>${idx + 1}</td><td>${r.date}</td><td style="color:${dayColor}; font-weight:bold;">${r.day}</td>
                    <td>${r.rank}</td><td style="font-weight:bold;">${r.name}</td><td>${r.notes || ''}</td></tr>`;
            });
            html += `</tbody></table>
                <div style="margin-top: 30px; font-size: 12px;">
                    <p style="font-weight:bold; margin-bottom:40px;">ملاحظة // على جميع الضباط تعبئة سجل الخفارة وتسليمه يوميا إلى أمر المعسكر قبل مغادرة المعسكر</p>
                    <div style="text-align: right; margin-right:50px;"><strong style="font-size:14px;">اعتماد مساعد آمر الكتيبة</strong></div>
                </div>`;
            printSlot.innerHTML = html; 
            setTimeout(() => window.print(), 150);
        }

        // ================== حضور الأفراد (أفقي) ==================
        function initSoldiersAttUI() {
            const compSelect = document.getElementById('soldier-att-company'); compSelect.innerHTML = `<option value="">-- اختر السرية --</option>`;
            db.companies.forEach(c => { if(c !== 'الضباط') compSelect.innerHTML += `<option value="${c}">${c}</option>`; });
            updateSoldierAttPlatoons();
        }
        function updateSoldierAttPlatoons() {
            const comp = document.getElementById('soldier-att-company').value; const platSelect = document.getElementById('soldier-att-platoon'); const platContainer = document.getElementById('soldier-att-platoon-container');
            platSelect.innerHTML = `<option value="">-- كل الفصائل / بدون تحديد --</option>`; db.platoons.forEach(p => platSelect.innerHTML += `<option value="${p}">${p}</option>`);
            if(comp) { platContainer.style.display = 'block'; } else { platContainer.style.display = 'none'; platSelect.value = ''; }
            renderSoldiersAttPreview();
        }
        function renderSoldiersAttPreview() {
            const comp = document.getElementById('soldier-att-company').value; const plat = document.getElementById('soldier-att-platoon').value;
            const tbody = document.getElementById('soldiers-att-preview-body'); tbody.innerHTML = '';
            if(!comp) { tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;">الرجاء اختيار السرية لعرض الأفراد</td></tr>`; return; }
            let soldiersToPrint = db.employees.filter(e => e.company === comp && (plat === '' || e.platoon === plat));
            if(soldiersToPrint.length === 0) { tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;">لا يوجد أفراد مسجلين</td></tr>`; return; }
            soldiersToPrint.forEach((s, idx) => { tbody.innerHTML += `<tr><td>${idx + 1}</td><td>${s.mil_id}</td><td><strong>${s.name}</strong></td><td>${s.company} ${s.platoon ? ' - ' + s.platoon : ''}</td></tr>`; });
        }
        
        function printSoldiersAttendance() {
            const comp = document.getElementById('soldier-att-company').value; const plat = document.getElementById('soldier-att-platoon').value;
            if(!comp) return alert("الرجاء اختيار السرية أولاً لطباعة الكشف.");
            
            setPrintOrientation('landscape'); 
            
            const sDay = document.getElementById('att-start-day').value || '........'; const sDate = document.getElementById('att-start-date').value || '................';
            const eDay = document.getElementById('att-end-day').value || '........'; const eDate = document.getElementById('att-end-date').value || '................';
            const lStart = document.getElementById('att-leave-start').value || '................'; const lEnd = document.getElementById('att-leave-end').value || '................';
            let soldiers = db.employees.filter(e => e.company === comp && (plat === '' || e.platoon === plat));

            let dateHeaders = []; let startObj = sDate && sDate !== '................' ? new Date(sDate) : null;
            for (let i = 0; i < 15; i++) {
                if (startObj && !isNaN(startObj.getTime())) {
                    let current = new Date(startObj); current.setDate(startObj.getDate() + i);
                    let dayNum = current.getDate().toString().padStart(2, '0'); let monthNum = (current.getMonth() + 1).toString().padStart(2, '0');
                    dateHeaders.push(`${dayNum}/${monthNum}`);
                } else { dateHeaders.push(''); }
            }

            document.getElementById('landscape-meta-content').innerHTML = `
                <div style="color: #8b0000; font-weight: bold; font-size: 14px; margin-bottom: 3px;">كشف: ${comp} ${plat ? ' / ' + plat : ''}</div>
                <div><strong>بداية العمل:</strong> يوم ${sDay} الموافق ${sDate}</div>
                <div><strong>نهاية العمل:</strong> يوم ${eDay} الموافق ${eDate}</div>
                <div><strong>الإجازة:</strong> من ${lStart} إلى ${lEnd}</div>
            `;

            const printSlot = document.getElementById('landscape-print-slot');
            let html = `
                <table class="print-table ls-table" style="width: 100%; border-collapse: collapse; direction: rtl; margin-top: 10px;">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width: 3%; border: 1px solid #000; padding: 4px;">ت</th>
                            <th rowspan="2" style="width: 12%; border: 1px solid #000; padding: 4px;">الرقم العسكري</th>
                            <th rowspan="2" style="width: 18%; border: 1px solid #000; padding: 4px;">الاسم الرباعي</th>
                            <th colspan="15" style="border: 1px solid #000; padding: 4px;">أيام العمل للتحضير (15 يوم)</th>
                            <th rowspan="2" style="width: 12%; border: 1px solid #000; padding: 4px;">ملاحظات</th>
                        </tr>
                        <tr>${dateHeaders.map(d => `<th style="width:3.6%; border: 1px solid #000; padding: 2px; font-size:11px;" class="yellow-bg">${d}</th>`).join('')}</tr>
                    </thead>
                    <tbody>
            `;
            const minRows = 22; const totalRows = Math.max(soldiers.length, minRows);
            for (let i = 0; i < totalRows; i++) {
                let s = soldiers[i] || { mil_id: '', name: '' }; let t_num = s.name ? (i + 1) : '';
                html += `<tr><td style="height: 22px; border: 1px solid #000;">${t_num}</td><td style="border: 1px solid #000;">${s.mil_id}</td><td style="font-weight:bold; border: 1px solid #000;">${s.name}</td>${Array(15).fill('<td style="border: 1px solid #000;"></td>').join('')}<td style="border: 1px solid #000;"></td></tr>`;
            }
            html += `</tbody></table>
                <div style="margin-top: 15px; display: flex; justify-content: space-between; font-size: 11px; font-weight: bold;">
                    <div style="text-align: center;"><strong>آمر السرية / الفصيل</strong><br><br>..................................</div>
                    <div style="text-align: center;"><strong>يعتمد / آمر الكتيبة 24 مشاة</strong><br><br>..................................</div>
                </div>`;
            printSlot.innerHTML = html; 
            setTimeout(() => window.print(), 150);
        }

        // ================== الأرشيف ==================
        function openListManager(type) {
            managingListType = type; document.getElementById('list-modal-title').innerText = type === 'companies' ? 'إدارة السرايا والضباط' : 'إدارة الفصائل';
            document.getElementById('new-list-item').value = ''; renderListManagerItems(); document.getElementById('list-manager-modal').classList.remove('hidden');
        }
        function renderListManagerItems() {
            const ul = document.getElementById('list-manager-items'); ul.innerHTML = '';
            db[managingListType].forEach((item, index) => { ul.innerHTML += `<li><span>${item}</span><div><button style="color: #3498db; margin-left:10px;" onclick="editListItem(${index})" title="تعديل"><i class="fa-solid fa-pen"></i></button><button style="color: #e74c3c;" onclick="deleteListItem(${index})" title="حذف"><i class="fa-solid fa-trash"></i></button></div></li>`; });
        }
        function addListItem() {
            const val = document.getElementById('new-list-item').value.trim();
            if(val && !db[managingListType].includes(val)) { db[managingListType].push(val); saveDB(); document.getElementById('new-list-item').value = ''; renderListManagerItems(); } else { alert('الاسم فارغ أو موجود مسبقاً!'); }
        }
        function editListItem(index) {
            const oldVal = db[managingListType][index]; const newVal = prompt('قم بتعديل الاسم:', oldVal);
            if(newVal && newVal.trim() !== '' && !db[managingListType].includes(newVal.trim())) { db[managingListType][index] = newVal.trim(); saveDB(); renderListManagerItems(); }
        }
        function deleteListItem(index) { if(confirm('هل أنت متأكد من الحذف؟')) { db[managingListType].splice(index, 1); saveDB(); renderListManagerItems(); } }
        function closeModal(modalId) { document.getElementById(modalId).classList.add('hidden'); if(modalId === 'list-manager-modal') { updateFilterDropdowns(); buildFormInputs(); initSoldiersAttUI(); } }

        function setupOfficialPrintTemplate(customHeaderHTML, hideSmallBox = false) {
            const metaContent = document.getElementById('print-meta-content');
            const smallBox = document.getElementById('print-small-box');
            if(customHeaderHTML !== null && customHeaderHTML !== undefined) { metaContent.innerHTML = customHeaderHTML; } 
            else {
                metaContent.innerHTML = `<div><strong>الموضــــــوع :</strong> ....................................</div><div><strong>التاريــــــــخ :</strong> ................... هـ &nbsp; / &nbsp; / &nbsp; 14</div><div><strong>الموافـــــــق :</strong> ................... م &nbsp; / &nbsp; / &nbsp; 20</div><div><strong>الرقم الإشاري :</strong> ................................</div>`;
            }
            smallBox.style.display = hideSmallBox ? 'none' : 'block';
        }

        function printAllTable(type) {
            setPrintOrientation('portrait');
            setupOfficialPrintTemplate(null, false);
            const printSlot = document.getElementById('print-content-slot');
            let dataToPrint = type === 'officers' ? activeOfficersData : activeSoldiersData;
            let title = type === 'officers' ? "كشف شؤون الضباط - الكتيبة 24 مشاة" : "كشف شؤون الأفراد - الكتيبة 24 مشاة";
            
            let html = `
                <div style="text-align: center; margin-bottom: 8px;">
                    <h3 style="font-size: 13px; font-weight: bold; color: #8b0000; border-bottom: 1.5px solid #8b0000; display: inline-block; padding-bottom: 2px; margin:0;">${title}</h3>
                </div>
                <table class="print-table">
                    <thead>
                        <tr>
                            <th style="width: 13%;">الرقم العسكري</th><th style="width: 12%;">الرتبة</th><th style="width: 28%;">الإسم الرباعي</th>
                            <th style="width: 15%;">رقم الهاتف</th><th style="width: 12%;">إسم المصرف</th><th style="width: 20%;">رقم الحساب</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            dataToPrint.forEach(emp => {
                html += `<tr><td><strong>${emp.mil_id || ''}</strong></td><td>${emp.rank || ''}</td><td><strong>${emp.name || ''}</strong></td>
                        <td>${emp.phone || ''}</td><td>${emp.bank || ''}</td><td>${emp.acc_num || ''}</td></tr>`;
            });
            html += `</tbody></table>
                <div style="margin-top: 30px; display: flex; justify-content: space-between; font-size: 12px;">
                    <div style="text-align: center;"><strong>رئيس قسم شؤون الأفراد والضباط</strong><br><br>..................................</div>
                    <div style="text-align: center;"><strong>يعتمد / آمر الكتيبة 24 مشاة</strong><br><br>..................................</div>
                </div>`;
            printSlot.innerHTML = html;
            setTimeout(() => window.print(), 150);
        }

        function printIndividual(milId) {
            const emp = db.employees.find(e => e.mil_id === milId); if(!emp) return;
            setPrintOrientation('portrait');
            setupOfficialPrintTemplate(null, false);
            const printSlot = document.getElementById('print-content-slot');
            
            let milPhoto = ''; let civPhoto = '';
            let milSlot = emp.archive.find(a => a.id === '1'); if(milSlot && milSlot.data) milPhoto = milSlot.data;
            let civSlot = emp.archive.find(a => a.id === '2'); if(civSlot && civSlot.data) civPhoto = civSlot.data;

            let html = `
                <div class="print-profile-header-images">
                    <div class="print-profile-photo">${civPhoto ? `<img src="${civPhoto}">` : `<div style="text-align:center; padding-top:40%; font-size:9px; color:#999;">صورة<br>مدنية</div>`}</div>
                    <div class="print-profile-title">بطاقة بيانات فرد / ضابط</div>
                    <div class="print-profile-photo">${milPhoto ? `<img src="${milPhoto}">` : `<div style="text-align:center; padding-top:40%; font-size:9px; color:#999;">صورة<br>عسكرية</div>`}</div>
                </div>
                <div class="print-profile-grid">
            `;
            for(let i = 0; i < fields.length; i += 2) {
                const f1 = fields[i]; const f2 = fields[i+1];
                html += `<div class="print-profile-row"><div class="print-profile-item"><strong>${f1.label}:</strong> ${emp[f1.key] || ''}</div>`;
                if(f2) { html += `<div class="print-profile-item"><strong>${f2.label}:</strong> ${emp[f2.key] || ''}</div>`; } else { html += `<div class="print-profile-item"></div>`; }
                html += `</div>`;
            }
            html += `</div>
                <div style="margin-top: 35px; display: flex; justify-content: space-between; font-size: 12px;">
                    <div style="text-align: center;"><strong>توقيع العسكري</strong><br><br>..................................</div>
                    <div style="text-align: center;"><strong>اعتماد ضابط شؤون الأفراد والضباط</strong><br><br>..................................</div>
                </div>`;
            printSlot.innerHTML = html;
            setTimeout(() => window.print(), 150);
        }

        function openArchiveModal(milId) {
            currentArchiveMilId = milId; const emp = db.employees.find(e => e.mil_id === milId); if(!emp) return;
            document.getElementById('archive-modal-title').innerText = `الأرشيف - ${emp.mil_id} | ${emp.name}`;
            renderArchiveGrid(emp); document.getElementById('archive-modal').classList.remove('hidden');
        }
        function renderArchiveGrid(emp) {
            const container = document.getElementById('archive-grid-container'); container.innerHTML = '';
            emp.archive.forEach(item => {
                let previewHtml = `<div class="archive-preview"><i class="fa-regular fa-image fa-3x"></i></div>`;
                if (item.data) {
                    if(item.data.startsWith('data:image')) { previewHtml = `<img src="${item.data}" class="archive-preview" alt="Preview">`; } 
                    else if (item.data.startsWith('data:application/pdf')) { previewHtml = `<div class="archive-preview" style="color:#e74c3c;"><i class="fa-solid fa-file-pdf fa-3x"></i></div>`; }
                }
                let deleteActionHtml = '';
                if(item.isFixed) { if(item.data) deleteActionHtml = `<button onclick="deleteArchiveData('${item.id}')" style="color:#e74c3c" title="مسح"><i class="fa-solid fa-eraser"></i> مسح</button>`; } 
                else { deleteActionHtml = `<button onclick="deleteArchiveSlot('${item.id}')" style="color:#e74c3c" title="حذف"><i class="fa-solid fa-trash"></i> حذف</button>`; }
                container.innerHTML += `
                    <div class="archive-item">
                        <h4>${item.title}</h4> ${previewHtml}
                        <div class="archive-actions">
                            <label for="file-upload-${item.id}" title="رفع/تغيير"><i class="fa-solid fa-upload"></i> رفع</label>
                            <input type="file" id="file-upload-${item.id}" accept="image/*, application/pdf" style="display:none" onchange="handleArchiveUpload(event, '${item.id}')">
                            ${item.data ? `<button onclick="viewArchiveFile('${item.id}')" title="عرض"><i class="fa-solid fa-eye"></i></button><button onclick="downloadArchiveFile('${item.id}', '${item.title}')" title="تنزيل"><i class="fa-solid fa-download"></i></button>` : ''}
                            ${deleteActionHtml}
                        </div>
                    </div>`;
            });
        }
        function addNewArchiveSlot() {
            const title = prompt("أدخل اسم المستند:"); if(!title || title.trim() === '') return;
            const emp = db.employees.find(e => e.mil_id === currentArchiveMilId);
            emp.archive.push({ id: 'custom_' + Date.now(), title: title.trim(), data: null, isFixed: false }); saveDB(); renderArchiveGrid(emp);
        }
        function handleArchiveUpload(event, itemId) {
            const file = event.target.files[0]; if (!file) return; const reader = new FileReader();
            reader.onload = function(e) {
                let result = e.target.result;
                if (file.type.startsWith('image/')) {
                    const img = new Image(); img.onload = function() {
                        const canvas = document.createElement('canvas'); const ctx = canvas.getContext('2d');
                        const MAX_WIDTH = 800; const scaleSize = MAX_WIDTH / img.width;
                        canvas.width = MAX_WIDTH; canvas.height = img.height * scaleSize;
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                        saveToArchive(itemId, canvas.toDataURL('image/jpeg', 0.7));
                    }; img.src = result;
                } else { saveToArchive(itemId, result); } 
            }; reader.readAsDataURL(file);
        }
        function saveToArchive(itemId, base64Data) { const emp = db.employees.find(e => e.mil_id === currentArchiveMilId); if(emp) { let slot = emp.archive.find(a => a.id === itemId); if(slot) slot.data = base64Data; saveDB(); renderArchiveGrid(emp); } }
        function deleteArchiveData(itemId) { if(confirm('هل تريد مسح هذا الملف؟')) { const emp = db.employees.find(e => e.mil_id === currentArchiveMilId); let slot = emp.archive.find(a => a.id === itemId); if(slot) slot.data = null; saveDB(); renderArchiveGrid(emp); } }
        function deleteArchiveSlot(itemId) { if(confirm('متأكد من حذف الخانة؟')) { const emp = db.employees.find(e => e.mil_id === currentArchiveMilId); emp.archive = emp.archive.filter(a => a.id !== itemId); saveDB(); renderArchiveGrid(emp); } }
        function viewArchiveFile(itemId) { const emp = db.employees.find(e => e.mil_id === currentArchiveMilId); if(emp) { let slot = emp.archive.find(a => a.id === itemId); if(slot && slot.data) { openBase64InNewTab(slot.data, slot.title); } } }
        function downloadArchiveFile(itemId, title) {
            const emp = db.employees.find(e => e.mil_id === currentArchiveMilId);
            if(emp) {
                let slot = emp.archive.find(a => a.id === itemId);
                if(slot && slot.data) {
                    const a = document.createElement('a'); a.href = slot.data;
                    let ext = slot.data.startsWith('data:application/pdf') ? 'pdf' : 'jpg';
                    a.download = `${emp.mil_id}_${title}.${ext}`; a.click();
                }
            }
        }
    </script>
</body>
</html>
