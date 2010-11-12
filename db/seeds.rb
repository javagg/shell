# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Role.create [{ :name => 'admin' },
             { :name => 'guest' },
             { :name => 'archive_read' },
             { :name => 'archive_write' }]

admin = User.new(:username => 'admin', :password => 'admin',
  :password_confirmation => 'admin', :email => 'no1@example.com')
admin_role = Role.find_by_name 'admin'
admin.roles << admin_role
admin.save
admin = User.find_by_username 'admin'
admin.activate!

guest = User.new(:username => 'guest', :password => '12345',
  :password_confirmation => '12345', :email => 'no2@example.com')
guest_role = Role.find_by_name 'guest'
guest.roles << guest_role
guest.save
guest = User.find_by_username 'guest'
guest.activate!

archive = User.new(:username => 'archive', :password => '12345',
  :password_confirmation => '12345', :email => 'no3@example.com')
archive_read_role = Role.find_by_name 'archive_read'
archive.roles << archive_read_role
archive.save
archive = User.find_by_username 'archive'
archive.activate!

# Archive test data
puts 'populating archive data'

Archive.create(
  :number => '103201001',
  :archive_type => '档案',
  :name => '10年会计报表',
  :issue_dep => 'FN',
  :keep_dep => 'FN',
  :keeper => '王晓彤',
  :origin_loc => 'FN部门1-4号文件柜',
  :expired_at => '2025/12/31',
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
  :origin_loc => 'CR文件柜',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/8/30',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/1',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/8',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/13',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/13',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/6',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/14',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/20',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/9/27',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/10/8',
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
  :origin_loc => 'HR部门X号文件柜',
  :expired_at => '2013/10/8',
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
  :origin_loc => 'HSSE文件柜',
  :state => '存档中',
  :has_backup => false,
  :has_electrical_edtion => false,
  :security_level => "非保密"
)

#HSSE	文件	HSSE管理体系手册	HSSE	HSSE	张驰	HSSE文件柜	2013/11/1	存档中	是	无	有	需要	非保密

Archive.create(
  :number => 'HSSE',
  :archive_type => '文件',
  :name => 'HSSE管理体系手册',
  :issue_dep => 'HSSE',
  :keep_dep => 'HSSE',
  :keeper => '张驰',
  :origin_loc => 'HSSE文件柜',
  :expired_at => '2013/11/8',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true,
  :security_level => "非保密"
)

#2009-F-01	文件	迎国庆加油送红旗活动申请	OP	OP	张励洁	OP-MKT文件柜	2009.10.1	存档中	是
Archive.create(
  :number => '2009-F-01',
  :archive_type => '文件',
  :name => '迎国庆加油送红旗活动申请',
  :issue_dep => 'OP',
  :keep_dep => 'OP',
  :keeper => '张励洁',
  :origin_loc => 'OP-MKT文件柜',
  :expired_at => '2009/10/1',
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
  :origin_loc => 'OP-MKT文件柜',
  :expired_at => '2009/10/12',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
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
  :origin_loc => 'OP-B2B文件柜',
  :state => '存档中',
  :has_backup => true,
  :has_electrical_edtion => true
)

