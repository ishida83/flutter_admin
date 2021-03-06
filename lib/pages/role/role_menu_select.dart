import 'package:cry/cry_tree_table.dart';
import 'package:cry/vo/tree_vo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/role_api.dart';
import 'package:flutter_admin/api/role_menu_api.dart';
import 'package:cry/cry_button.dart';
import 'package:flutter_admin/models/menu.dart';
import 'package:cry/model/request_body_api.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/models/role.dart';
import 'package:flutter_admin/models/role_menu.dart';
import 'package:flutter_admin/utils/tree_util.dart';
import 'package:flutter_admin/utils/utils.dart';

class RoleMenuSelect extends StatefulWidget {
  final Function onEdit;
  final VoidCallback reloadData;
  final List<TreeVO<Menu>> treeVOList;
  final Role role;

  RoleMenuSelect({
    this.onEdit,
    this.treeVOList,
    this.reloadData,
    @required this.role,
  });

  @override
  _RoleMenuSelectState createState() => _RoleMenuSelectState();
}

class _RoleMenuSelectState extends State<RoleMenuSelect> {
  List<TreeVO<Menu>> data;
  final GlobalKey<CryTreeTableState> treeTableKey = GlobalKey<CryTreeTableState>();

  @override
  void initState() {
    super.initState();
    this._loadData();
  }

  @override
  Widget build(BuildContext context) {
    List<CryTreeTableColumnData> columnData = [
      CryTreeTableColumnData('名称', (Menu v) => v.name),
      CryTreeTableColumnData('英文名', (Menu v) => v.nameEn),
      CryTreeTableColumnData('URL', (Menu v) => v.url),
      CryTreeTableColumnData('顺序号', (Menu v) => v.orderBy?.toString(), width: 80),
      CryTreeTableColumnData('备注', (Menu v) => v.remark, width: 300)
    ];
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        CryButton(
          iconData: Icons.save,
          label: '保存',
          onPressed: () => save(),
        ),
        CryButton(
          iconData: Icons.close,
          label: '关闭',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    var treeTable = CryTreeTable<Menu>(
      key: treeTableKey,
      columnData: columnData,
      data: data,
      onSelected: (v) => _onSelected(v),
      tableWidth: 1300,
      selectType: CryTreeTableSelectType.parentCascadeTrue,
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text('关联菜单'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [treeTable],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return result;
  }

  save() async {
    List<Menu> selectedList = treeTableKey.currentState.getSelectedData();
    List roleMenuList = selectedList.map((e) => RoleMenu(roleId: widget.role.id, menuId: e.id).toMap()).toList();
    await RoleMenuApi.saveBatch(roleMenuList);
    Utils.message('保存成功');
    Navigator.pop(context);
  }

  _loadData() async {
    ResponseBodyApi responseBodyApi = await RoleApi.getMenu(RequestBodyApi(params: widget.role.toJson()).toMap());
    var data = responseBodyApi.data;
    List<Menu> list = List.from(data).map((e) => Menu.fromMap(e)).toList();
    this.data = TreeUtil.toTreeVOList(list);
    this.setState(() {});
  }

  _onSelected(TreeVO<Menu> v) {
    setState(() {});
  }
}
