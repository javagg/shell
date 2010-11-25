
Setting.create(:var => 'upload_limit', 
  :description => '该参数设置系统上传附件的最大允许值。例如，500.kilobytes, 5.megabytes',
  :value => '10.megabytes')

Setting.create(:var => 'reminder_sending_time', 
  :description => '提醒邮件的每日发送时间。例如，00:00:00, 06:00:00, 18:30:00',
  :value => '00:00:00')


Role.create [
  { :name => 'admin', :description => '系统管理员身份，拥有所有权限，包括：用户管理，系统设置，文档、证照、合同的新建、修改、删除权限' },
#  { :name => 'user', :description => '系统注册用户，可以访问公共页面，需要管理员为其分配权限' },
  { :name => 'archive_view', :description => '文档只读权限，可以查看系统管理的文档' },
  { :name => 'archive_manage', :description => '文档读写权限，可以新建、修改、删除系统管理的文档' },
  { :name => 'license_view', :description => '证照只读权限，可以查看系统管理的证照' },
  { :name => 'license_manage', :description => '证照读写权限，可以新建、修改、删除系统管理的证照' },
  { :name => 'contract_view', :description => '合同只读权限，可以查看系统管理的合同' },
  { :name => 'contract_manage', :description => '合同读写权限，可以新建、修改、删除系统管理的合同' }]

admin = User.new(:username => 'admin', :password => 'admin',
  :password_confirmation => 'admin', :email => 'no1@example.com')
admin_role = Role.find_by_name 'admin'
admin.roles << admin_role
admin.save
admin = User.find_by_username 'admin'
admin.activate!

archive_viewer = User.new(:username => 'archive_viewer', :password => '12345',
  :password_confirmation => '12345', :email => 'no3@example.com')
archive_view_role = Role.find_by_name 'archive_view'
archive_viewer.roles << archive_view_role
archive_viewer.save
archive_viewer = User.find_by_username 'archive_viewer'
archive_viewer.activate!

archive_manager = User.new(:username => 'archive_manager', :password => '12345',
  :password_confirmation => '12345', :email => 'no4@example.com')
archive_manage_role = Role.find_by_name 'archive_manage'
archive_manager.roles << archive_manage_role
archive_manager.save
archive_manager = User.find_by_username 'archive_manager'
archive_manager.activate!

license_viewer = User.new(:username => 'license_viewer', :password => '12345',
  :password_confirmation => '12345', :email => 'no5@example.com')
license_view_role = Role.find_by_name 'license_view'
license_viewer.roles << license_view_role
license_viewer.save
license_viewer = User.find_by_username 'license_viewer'
license_viewer.activate!

license_manager = User.new(:username => 'license_manager', :password => '12345',
  :password_confirmation => '12345', :email => 'no6@example.com')
license_manage_role = Role.find_by_name 'license_manage'
license_manager.roles << license_manage_role
license_manager.save
license_manager = User.find_by_username 'license_manager'
license_manager.activate!

contract_viewer = User.new(:username => 'contract_viewer', :password => '12345',
  :password_confirmation => '12345', :email => 'no7@example.com')
contract_view_role = Role.find_by_name 'contract_view'
contract_viewer.roles << contract_view_role
contract_viewer.save
contract_viewer = User.find_by_username 'contract_viewer'
contract_viewer.activate!

contract_manager = User.new(:username => 'contract_manager', :password => '12345',
  :password_confirmation => '12345', :email => 'no8@example.com')
contract_manage_role = Role.find_by_name 'contract_manage'
contract_manager.roles << contract_manage_role
contract_manager.save
contract_manager = User.find_by_username 'contract_manager'
contract_manager.activate!

puts 'populating archive samples'

Archive.create(
  :number => '103201001',
  :archive_type => '档案',
  :name => '10年会计报表',
  :issue_dep => 'FN',
  :keep_dep => 'FN',
  :keeper => '王晓彤',
  :original_loc => 'FN部门1-4号文件柜',
  :expired_on => '2025/12/31',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true
)

Archive.create(
  :number => '201201001',
  :archive_type => '文件',
  :name => '会计岗位SOP',
  :issue_dep => 'FN',
  :keep_dep => 'FN',
  :keeper => '刘大莹',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true
)

# 档案	商品资料	OP	OP	杨娜	CR文件柜		暂未存档	否

Archive.create(
  :archive_type => '档案',
  :name => '商品资料',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '杨娜',
  :original_loc => 'CR文件柜',
  :state => '暂未存档',
  :has_backup => false
)

#	内控文件	运营手册	OP	OP	杨娜			存档中	是
Archive.create(
  :archive_type => '内控文件',
  :name => '运营手册',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

#	标准	工程施工标准	EN	EN	黄晓璐			外借中	是
Archive.create(
  :archive_type => '标准',
  :name => '工程施工标准',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

#	清单	工作清单	EN	EN	黄晓璐			存档中	是
Archive.create(
  :archive_type => '清单',
  :name => '工作清单',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

#	检查表	施工安全检查表	EN	EN	黄晓璐			存档中	是
Archive.create(
  :archive_type => '检查表',
  :name => '施工安全检查表',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

#	许可证	开工许可证	EN	EN	黄晓璐			存档中	是
Archive.create(
  :archive_type => '许可证',
  :name => '开工许可证',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

# 许可证	高空作业许可证	EN	EN	黄晓璐			存档中	是

Archive.create(
  :archive_type => '许可证',
  :name => '高空作业许可证',
  :issue_dep => 'EN',
  :keep_dep => 'EN',
  :keeper => '黄晓璐',
  :state => '存档中',
  :has_backup => true
)

# 000454	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/8/30	存档中	是

Archive.create(
  :number => '000454',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/8/30',
  :state => '存档中',
  :has_backup => true
)

# 000455	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/1	存档中	是
Archive.create(
  :number => '000455',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/1',
  :state => '存档中',
  :has_backup => true
)

# 000456	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/8	存档中	是
Archive.create(
  :number => '000456',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/8',
  :state => '存档中',
  :has_backup => true
)

# 000457	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/13	存档中	是
Archive.create(
  :number => '000457',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/13',
  :state => '存档中',
  :has_backup => true
)

# 000458	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/13	存档中	是
Archive.create(
  :number => '000458',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/13',
  :state => '存档中',
  :has_backup => true
)

#000459	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/6	存档中	是
Archive.create(
  :number => '000459',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/6',
  :state => '存档中',
  :has_backup => true
)

#000460	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/14	存档中	是
Archive.create(
  :number => '000460',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/14',
  :state => '存档中',
  :has_backup => true
)

#000462	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/20	存档中	是
Archive.create(
  :number => '000462',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/20',
  :state => '存档中',
  :has_backup => true
)
#000476	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/9/27	存档中	是
Archive.create(
  :number => '000476',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/9/27',
  :state => '存档中',
  :has_backup => true
)

#000468	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/10/8	存档中	是
Archive.create(
  :number => '000468',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/10/8',
  :state => '存档中',
  :has_backup => true
)

#000469	档案	人事档案	HR	HR	李世梅	HR部门X号文件柜	2013/10/8	存档中	是
Archive.create(
  :number => '000469',
  :archive_type => '档案',
  :name => '人事档案',
  :issue_dep => 'HR',
  :keep_dep => 'HR',
  :keeper => '李世梅',
  :original_loc => 'HR部门X号文件柜',
  :expired_on => '2013/10/8',
  :state => '存档中',
  :has_backup => true
)

#HSSE	文件	ESA报告	HSSE	HSSE	杨鹏飞	HSSE文件柜		存档中	否	无	无	无	非保密
Archive.create(
  :number => 'HSSE',
  :archive_type => '文件',
  :name => 'ESA报告',
  :issue_dep => 'HSSE',
  :keep_dep => 'HSSE',
  :keeper => '杨鹏飞',
  :original_loc => 'HSSE文件柜',
  :state => '存档中',
  :has_backup => false,
  :has_electrical_edtion => false,
  :confidential_level => "非保密"
)

#HSSE	文件	HSSE管理体系手册	HSSE	HSSE	张驰	HSSE文件柜	2013/11/1	存档中	是	无	有	需要	非保密

Archive.create(
  :number => 'HSSE',
  :archive_type => '文件',
  :name => 'HSSE管理体系手册',
  :issue_dep => 'HSSE',
  :keep_dep => 'HSSE',
  :keeper => '张驰',
  :original_loc => 'HSSE文件柜',
  :expired_on => '2013/11/8',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true,
  :confidential_level => "非保密"
)

#2009-F-01	文件	迎国庆加油送红旗活动申请	OP	OP	张励洁	OP-MKT文件柜	2009.10.1	存档中	是
Archive.create(
  :number => '2009-F-01',
  :archive_type => '文件',
  :name => '迎国庆加油送红旗活动申请',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '张励洁',
  :original_loc => 'OP-MKT文件柜',
  :expired_on => '2009/10/1',
  :state => '存档中',
  :has_backup => true
)

#2009-NF-01	文件	红光站开业活动申请	OP	OP	张励洁	OP-MKT文件柜	2009.10.12	存档中	是
Archive.create(
  :number => '2009-NF-01',
  :archive_type => '文件',
  :name => '红光站开业活动申请',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '张励洁',
  :original_loc => 'OP-MKT文件柜',
  :expired_on => '2009/10/12',
  :state => '存档中',
  :has_backup => true
)

#QSBG-FL	请示报告	客户返利请示报告	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'QSBG-FL',
  :archive_type => '请示报告',
  :name => '客户返利请示报告',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)
#QSBG-XD	请示报告	信贷客户请示报告	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'QSBG-XD',
  :archive_type => '请示报告',
  :name => '信贷客户请示报告',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)
#QSBG-ZX	请示报告	直销业务请示报告	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'QSBG-ZX',
  :archive_type => '请示报告',
  :name => '直销业务请示报告',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)
#CG--RC1	日常申购单	采购合同审批单	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'CG--RC1',
  :archive_type => '日常申购单',
  :name => '采购合同审批单',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)
#HT-FL	合同	车队卡设备采购合同	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'HT-FL',
  :archive_type => '合同',
  :name => '车队卡设备采购合同',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)

#HT-WK	合同	万科合作合同	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'HT-WK',
  :archive_type => '合同',
  :name => '万科合作合同',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)

#HT-DL	合同	电路租用合同	OP	OP	周艳	OP-B2B文件柜		存档中	是
Archive.create(
  :number => 'HT-DL',
  :archive_type => '合同',
  :name => '电路租用合同',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true
)
#LC-KK	内控文件	客户开卡流程	OP	OP	周艳	OP-B2B文件柜					电子版
Archive.create(
  :number => 'LC-KK',
  :archive_type => '内控文件',
  :name => '客户开卡流程',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true
)
#LC-XD	内控文件	信贷流程	OP	OP	周艳	OP-B2B文件柜					电子版
Archive.create(
  :number => 'LC-XD',
  :archive_type => '内控文件',
  :name => '信贷流程',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '周艳',
  :original_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true
)

puts 'populating license samples'
# 西安	陕西延长壳牌石油有限公司阿房加油站	营业执照	610000500005696	陕西省工商行政管理局	2009.6.26	3.1	2039.6.25	正本:OP	副本:PR
License.create(
  :number => '610000500005696',
  :station_name => '陕西延长壳牌石油有限公司阿房加油站',
  :name => '营业执照',
  :issuing_authority => '陕西省工商行政管理局',
  :issuing_date => '2009/6/26',
  :area => '西安',
  :annual_inspection_date => '2010/3/1',
  :expired_on => '2039/6/25',
  :original_loc => 'OR',
  :backup_loc => 'PR'
)

# 西安	陕西延长壳牌石油有限公司阿房加油站	成品油零售经营批准证书	6101121023	陕西省商务厅	2009.4.3	2009.12.31	2010.4.2	正本:OP	副本:PR
License.create(
  :number => '6101121023',
  :station_name => '陕西延长壳牌石油有限公司阿房加油站',
  :name => '成品油零售经营批准证书',
  :issuing_authority => '陕西省商务厅',
  :issuing_date => '2009/4/3',
  :area => '西安',
  :annual_inspection_date => '2009/12/31',
  :expired_on => '2010/4/2',
  :original_loc => 'OR',
  :backup_loc => 'PR'
)

#	西安	陕西延长壳牌石油有限公司阿房加油站	危险化学品经营许可证	陕西油（甲）字【2009】000187
#	陕西省安全生产监督管理局	2009.6.4	2010.7.22	2010.10.22	正本:OP	副本:PR
License.create(
  :number => '陕西油（甲）字【2009】000187',
  :station_name => '陕西延长壳牌石油有限公司阿房加油站',
  :name => '危险化学品经营许可证',
  :issuing_authority => '陕西省安全生产监督管理局',
  :issuing_date => '2009/6/4',
  :area => '西安',
  :annual_inspection_date => '2009/7/22',
  :expired_on => '2010/10/22',
  :original_loc => 'OR',
  :backup_loc => 'PR'
)

# 	西安	陕西延长壳牌石油有限公司阿房加油站	组织机构代码证（正副、IC卡）	69110430-X
# 	陕西省质量技术监督局	2009.7.1	2010.6.10.	2010.10.22	PR	2009年已检

License.create(
  :number => '69110430-X',
  :station_name => '陕西延长壳牌石油有限公司阿房加油站',
  :name => '组织机构代码证（正副、IC卡）',
  :issuing_authority => '陕西省质量技术监督局',
  :issuing_date => '2009/7/1',
  :area => '西安',
  :annual_inspection_date => '2009/6/10',
  :expired_on => '2010/10/22',
  :original_loc => 'PR',
  :memo => '2009年已检'
)

#	西安	陕西延长壳牌石油有限公司阿房加油站	食品卫生许可证	【2009】第610100-0179	西安市卫生局
#	2009.5.12		2013.5.11	正本:OP	发证日起每满一年1月起复核，有效期截止日期前三个月，必须申请办理换证手续

License.create(
  :number => '【2009】第610100-0179X',
  :station_name => '陕西延长壳牌石油有限公司阿房加油站',
  :name => '食品卫生许可证',
  :issuing_authority => '西安市卫生局',
  :issuing_date => '2009/5/12',
  :area => '西安',
  :expired_on => '2013/5/11',
  :original_loc => 'OP',
  :backup_loc => 'PR',
  :memo => '发证日起每满一年1月起复核，有效期截止日期前三个月，必须申请办理换证手续'
)

#	西安	陕西延长壳牌石油有限公司西安太华北路西加油站	食品流通许可证	SP6101350930000383	西安市工商行政管理局双生分局
#		2009.12.10		2012.12.9	正本:OP	有效期满前30日内，申请换证副本:PR
License.create(
  :number => 'SP6101350930000383',
  :station_name => '陕西延长壳牌石油有限公司西安太华北路西加油站',
  :name => '食品流通许可证',
  :issuing_authority => '西安市工商行政管理局双生分局',
  :issuing_date => '2009/12/10',
  :area => '西安',
  :expired_on => '2012/12/9',
  :original_loc => 'OP',
  :backup_loc => 'PR',
  :memo => '有效期满前30日内，申请换证副本'
)

# 咸阳	延长壳牌石油有限公司武功长青加油站	消防意见书	武公【2010】第004号	武功县公安消防大队
# 2010.3.29		1年	法务部

License.create(
  :number => '武公【2010】第004号',
  :station_name => '延长壳牌石油有限公司武功长青加油站',
  :name => '消防意见书',
  :issuing_authority => '武功县公安消防大队',
  :issuing_date => '2010/3/29',
  :area => '咸阳',
  :expired_on => '2011/3/29',
  :original_loc => '法务部'
)

#	西安	陕西延长壳牌石油有限公司太华北路加油站	防雷防静电检测书	0036671	陕西省气象局	09.9.17	2010.3
License.create(
  :number => '0036671',
  :station_name => '陕西延长壳牌石油有限公司太华北路加油站',
  :name => '防雷防静电检测书',
  :issuing_authority => '陕西省气象局',
  :issuing_date => '2009/9/17',
  :annual_inspection_date => '2010/3/1',
  :area => '西安',
  :expired_on => '2010/9/17'
)

#	西安	延长壳牌石油有限公司	税务登记证	610198681575394	西安高新技术开发区国家税务局	2010.6.1	营业执照年检后60内（统一联合年检)		正本：公司
#									副本:FN
License.create(
  :number => '610198681575394',
  :station_name => '延长壳牌石油有限公司',
  :name => '税务登记证',
  :issuing_authority => '西安高新技术开发区国家税务局',
  :issuing_date => '2010/6/1',
  :area => '西安',
  :expired_on => '2050/6/1',
  :original_loc => '公司',
  :backup_loc => 'FN'
)

# 西安	延长壳牌石油有限公司西安丈八四路加油站	税务登记证	610198691116466	西安高新技术开发区国家税务局
# 	2010.7.21			正本：丈八四油站 	副本:FN
License.create(
  :number => '610198691116466',
  :station_name => '延长壳牌石油有限公司西安丈八四路加油站',
  :name => '税务登记证',
  :issuing_authority => '西安高新技术开发区国家税务局',
  :issuing_date => '2010/7/21',
  :area => '西安',
  :original_loc => '丈八四油站',
  :backup_loc => 'FN'
)

# R11003	西安	丈八北路加油站	土地使用权证	"西雁国用2009出第468号
#	西安市国土资源局	2009/11/12	N/A	2045.11.7	法务	面积1713.5
License.create(
  :t5code => 'R11003',
  :number => '西雁国用2009出第468号',
  :station_name => '丈八北路加油站',
  :name => '土地使用权证',
  :issuing_authority => '西安市国土资源局',
  :issuing_date => '2009/11/12',
  :area => '西安',
  :expired_on => '2045/11/7',
  :original_loc => '法务',
  :memo => '面积1713.5'
)

#R11006	咸阳	咸阳咸宋路加油站	土地使用权证	"咸国用2009第154号
#	咸阳市国土资源局	2009/8/26	N/A	2049.5	法务	面积2049.5
License.create(
  :t5code => 'R11006',
  :number => '咸国用2009第154号',
  :station_name => '咸阳咸宋路加油站',
  :name => '土地使用权证',
  :issuing_authority => '咸阳市国土资源局',
  :issuing_date => '2009/8/26',
  :area => '咸阳',
  :expired_on => '2049/5/1',
  :original_loc => '法务',
  :memo => '面积2049.5'
)
#R11015	宝鸡	宝鸡陈仓大道加油站	土地使用权证	"宝市国用2009第266号
#	宝鸡市国土资源局	2009/12/31	N/A	2049.12.15	法务	面积3627
License.create(
  :t5code => 'R11015',
  :number => '宝市国用2009第266号',
  :station_name => '宝鸡陈仓大道加油站',
  :name => '土地使用权证',
  :issuing_authority => '宝鸡市国土资源局',
  :issuing_date => '2009/12/31',
  :area => '宝鸡',
  :expired_on => '2049/12/15',
  :original_loc => '法务',
  :memo => '面积3627'
)

puts 'populating contract samples'
#	加油站合同		R11004	咸阳人民东路加油站	咸阳市人民东路与金旭路交汇处	购买
#	2009/4/20	2009/8/5	咸阳鑫鼎物资贸易有限公司		N/A	N/A	N/A	R11004	ND	1260万元
#		高瑜		\/		HR资料室文件柜	是	FN	Legal/FN/ND	高
Contract.create(
  :name => '咸阳人民东路加油站',
  :number => 'R11004',
  :station_name => '咸阳人民东路加油站',
  :project_address => '咸阳市人民东路与金旭路交汇处',
  :trading_mode => '购买',
  :land_certificate_application_deadline => '2009/4/20',
  :property_certificate_application_deadline => '2009/8/5',
  :other_party => '咸阳鑫鼎物资贸易有限公司',
  :expense_paid => 'R11004',
  :owning_department => 'ND',
  :amount => 12600000.00,
  :holder => '高瑜',
  :transferred => true,
  :original_loc => 'HR资料室文件柜',
  :has_backup => true,
  :backup_loc => 'FN',
  :has_electrical_edtion => true,
  :confidential_level => '高'
)

#	采购合同		M-0003		李波 朱向东	唐延国际中心写字间租赁合同	2009/1/1		2011/6/30
#			HR	50/月/㎡	田莉	杨子薇	\/																		Y

Contract.create(
  :name => '唐延国际中心写字间租赁合同',
  :contract_type => '采购合同',
  :number => 'M-0003',
  :other_party => '李波，朱向东',
  :contract_content => '唐延国际中心写字间租赁合同',
  :owning_department => 'HR',
  :holder => '田莉',
  :executive => '杨子薇',
  :transferred => true,
  :memo => '已签订补充协议，说明合同终止'
)

#采购合同	购销	C1170						西安轻松印务有限责任公司	新配方第二波宣传单和积分卡印刷
##		2010/9/26		执行完毕	油站	OP	32,400.00 		张励洁

Contract.create(
  :name => '西安轻松印务有限责任公司的合同',
  :contract_type => '采购合同',
  :stamp_tax_type => '购销',
  :number => 'C1170',
  :other_party => '西安轻松印务有限责任公司',
  :contract_content => '新配方第二波宣传单和积分卡印刷',
  :start_date => '2010/9/26',
  :amount => 32400.00,
  :expense_paid => '油站',
  :owning_department => 'OP',
  :executive => '张励洁'
)