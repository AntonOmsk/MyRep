// ����� ���� �뫠 ��諥��� ��१���, �⮡� �� ��������� �஡��� � ࠧ���襭��� ��室�����
// ����� ��� �� ����ᠭ � ����ன���� ।���� Delphi:
// Block indent = 2
// Tab Stop = 2.
// Use tab character - ����祭
// Right margin = 140
// �� ⠪�� ��ࠬ���� ��ࠢ������� � ���� ������ �룫拉�� ��������� �����⭮ �� �ᥬ� ����

procedure TMainForm.MakeActionToolbar();
var
	FormID: TActionToolbarWindow;
	BeginGroupZakup, DoGroup: Boolean;
	j, z, Oldlen: Integer;

	function GetClassIndex(const CName: string): Integer;
	var
		i: Integer;
	begin
		for i := 0 to MDIFormsClassCount do
		begin
			if MDIFormsClassNameList[i] = CName then
			begin
				if CName = 'TfrmPlanGraf' then
				begin
 					if TfrmPlanGraf(ActiveMDIChild).SelectedZakonID = 44 then
						Exit(6) // atwPlanGraf44
					else
						Exit(9); // atwPlanZakup223
        end;

				Exit(i);
			end;
		end;

		raise Exception.Create(msgClassByNameNotFound);
	end;

	procedure SetToolBarYearVisible;
	begin
		// �㦭� ��⠭����� ��������� �㫡��� �� ���뢠���� �ଥ
		case FormID of
			atwOwners: MakeYearToolbar((ActiveMDIChild as TfrmGZOwners).ComboFinYears);
			atwReestr: MakeYearToolbar(
				(ActiveMDIChild as TfrmReestr).ComboFinYears,
				(ActiveMDIChild as TfrmReestr).ComboFinYears2);

			atwNotReestr: MakeYearToolbar(
				(ActiveMDIChild as TfrmNotReestr).ComboFinYears,
				(ActiveMDIChild as TfrmNotReestr).ComboFinYears2);

			atwOKPD2: MakeYearToolbar(nil);
			atwOKVED2: MakeYearToolbar(nil);
			atwDocTypes: MakeYearToolbar(nil);
			atwIstFinance: MakeYearToolbar(nil);
			atwMasters: MakeYearToolbar(nil);
			atwCities: MakeYearToolbar(nil);
			atwOtherClassOKPD: MakeYearToolbar(nil);
			atwOtherClassOKVED: MakeYearToolbar(nil);
			atwOtherClassOKDP: MakeYearToolbar(nil);
		end;
	end;

begin
	// �᫨ ���� � �㫡�஬, ��⠭�������� ��������� �㫡�஢ �� �ଥ
	if (ActiveMDIChild is TMDIFormTB) and (ActiveMDIChild.ClassName <> str_Desktop) then
	begin
		FormID := TActionToolbarWindow(GetClassIndex(ActiveMDIChild.ClassName));
	end
	else
	begin
		// ��� ���� �ந�室�� ⮫쪮 � ��砥 ����� �����뢠���� ���� ��� �㫡�஢(���� ���� dxBar_ScreenSpace)
		// �०�� 祬 ���⨬ �㫡���, ��३��� �� �।����� �������(�� �㤥� ���室��� �� �������� ����⢨�)
		dxRibbon.ActiveTab := LastRibbonTab;
		ClearToolbars(dxRibbon_Actions);

		if Assigned(ActiveMDIChild) and (ActiveMDIChild.ClassName <> str_Desktop) then
			LastActiveWindowHandle := ActiveMDIChild.Handle
		else
			LastActiveWindowHandle := 0;

		Exit;
	end;

	// ��⨬����� 3. �᫨ �㫡�� 㦥 ���ᮢ�� (���짮��⥫� ���襫 �� �������� ����⢨� ᠬ)
	if LastActiveWindowHandle <> ActiveMDIChild.Handle then
	begin
		// ��஥� �� ᮤ�ন���
		// ��⨬����� 1.
		// �㦭� ��易⥫쭮 ᭠砫� ����� �� ᮤ�ন��� ��������, �� ��㯭��� � ������, �⮡� ������� ����ᮢ��
		ClearToolbars(dxRibbon_Actions);

		dxRibbon.BeginUpdate;
		SetToolBarYearVisible;

		// �������: ���冷� �맮�� SetToolbarActive �� ��।���� ���冷� �⮡ࠦ���� �㫡�஢ ᫥�� ���ࠢ�
		// �� ���冷� ����� ����砫쭮 �� ������� �ଥ �� ਡ����. SetToolbarActive ॣ㫨���� ⮫쪮 ���������
		case FormID of
			{$REGION ' atwOwners '}
			atwOwners:
			begin
				with (ActiveMDIChild as TfrmGZOwners) do
				begin
					// ��⨬����� 2.
					// ���砫� �����稬 ��������� ������� �� ��������� �㫡��, � ⮫쪮 � ���� ������� �㫡���
					// �����稬 ����⢨� ������� dxBar_MainObjectActions
					AddTBItem(dxBar_MainObjectActions, dxButton_New, ActionNew);
					AddTBItem(dxBar_MainObjectActions, dxButton_Property, ActionEdit);
					AddTBItem(dxBar_MainObjectActions, dxButton_Delete, ActionDelete);
					AddTBItem(dxBar_MainObjectActions, dxButton_Refresh, ActionRefresh);
					AddTBItem(dxBar_MainObjectActions, dxButton_Search, ActionFind);
					AddTBItem(dxBar_MainObjectActions, dxButton_Filter, ActionFilter);

					{$IFDEF MULTI_OWNERS}
						AddTBItem(dxBar_MultiZakup, dxButton_MultiPlanZakup44, ActionPlanZakup44);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiPlanGraf, ActionPlanGraf44);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNotices44, ActionViewNotices);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiPlanZakup223, ActionPlanGraf223, '', [], True);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNotices223, ActionViewNotices223); // ����饭�� 223 �� �� ��⮢�

						AddTBItem(
							dxBar_MultiZakup,
							dxButton_MultiReestr,
							ActionViewReestr,
							dxPopupMenu_MultiReestr,
							[ActionViewSpec, ActionViewOplat, ActionViewNotReestr{, ActionViewNotices223}],
							'',
							[],
							True); // ����饭�� 223 �� �� ��⮢�

						AddTBItem(dxBar_MultiZakup, dxContainer_MultiLimits, 24);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiLimitFin, ActionLimitsFin, dxContainer_MultiLimits);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiLimitAnalys, ActionLimitAnalize, dxContainer_MultiLimits);

						AddTBItem(dxBar_MultiZakup, dxContainer_MultiHelpers, 83);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK, ActionViewCenaAccount, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK102, ActionViewNMCK102, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK871, ActionViewCenaAccount871, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiGRLS, ActionViewGRLS, dxContainer_MultiHelpers);
					{$ENDIF}

					// �����稬 ����⢨� ������� dxBar_Integration
					AddTBItem(dxBar_Integration, dxButton_ImportFromPortal, ActionImportFromOOS, '', [ivlLargeIconWithText]);

					// �����稬 ����⢨� ������� dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportXLS, ActionExport, '', [], True); // �����筠� ������ ��� �믠���饣� ᯨ᪠;
					AddTBItem(dxBar_Integration, dxButton_ImportXLS, ActionImport); // �����筠� ������ ��� �믠���饣� ᯨ᪠;

					{$IFDEF MULTI_OWNERS}
					AddTBItem(dxBar_Data, dxButton_CheckActual, ActionCheckActual);
					AddTBItem(dxBar_Data, dxButton_NoticeSchedule, ActionNoticeSchedule);
					{$ENDIF}

					// �����稬 ����⢨� ������� dxBar_Data
					AddTBItem(dxBar_Data, dxButton_Plan, ActionCheckInRNP);
					AddTBItem(dxBar_Data, dxButton_Notice, ActionCheckInSMP);

					// ���� "������" - �࣠������
					SetToolbarActive(dxBar_MainObjectActions, strRibbonToolbarOrg);

					{$IFDEF MULTI_OWNERS}
						// ���� "���㯪� �� �࣠����樨" - ���㯪� �� �࣠����樨
						SetToolbarActive(dxBar_MultiZakup, strRibbonToolbarMultiZakup);
					{$ENDIF}

					// ���� "��⥣���" - ��⥣���
					SetToolbarActive(dxBar_Integration, strRibbonToolbarIntegration);

					// ���� "��ࢨ�" - ����� ॥���
					SetToolbarActive(dxBar_Data, strRibbonToolbarService);
				end;
			end;
			{$ENDREGION}

			{$REGION ' atwPlanZakup44 '}
			atwPlanZakup44:
			begin
				with (ActiveMDIChild as TfrmPlanZakup) do
				begin
					// �����稬 ����⢨� ������� dxBar_MainObjectActions
					AddTBItem(dxBar_MainObjectActions, dxButton_New, ActionNew, dxPopupMenu_Copy, ActionCopy, strRibbonActionNew);
					AddTBItem(dxBar_MainObjectActions, dxButton_Property, ActionEdit);
					AddTBItem(dxBar_MainObjectActions, dxButton_Delete, ActionDelete);
					AddTBItem(dxBar_MainObjectActions, dxButton_Refresh, ActionRefresh);
					AddTBItem(dxBar_MainObjectActions, dxButton_Search, ActionFind);
					AddTBItem(dxBar_MainObjectActions, dxButton_Filter, ActionFilter);

					// �����稬 ����⢨� ������� dxBar_MinorObjectActions
					AddTBItem(dxBar_MinorObjectActions, dxButton_MinorNew, ActionNewPlan, strRibbonActionNewPlan);
					AddTBItem(
						dxBar_MinorObjectActions, dxButton_MinorProperty, ActionEditPlan, strRibbonActionEditPlan);
					AddTBItem(
						dxBar_MinorObjectActions, dxButton_MinorDelete, ActionDeletePlan, strRibbonActionDeletePlan);

					// �����稬 ����⢨� ������� dxBar_PrintForms
					AddTBItem(dxBar_PrintForms, dxButton_XLSForm, ActionPrintXLSForm);
					AddTBItem(dxBar_PrintForms, dxButton_Rational, ActionSolutionForm);

					// �����稬 ����⢨� ������� dxBar_Integration
					AddTBItem(dxBar_Integration, dxButton_ExportToPortal, ActionExportXLS4OOS, '', [ivlLargeIconWithText]);
					AddTBItem(dxBar_Integration, dxButton_ImportFromPortal, ActionImportFromOOS,  '', [ivlLargeIconWithText]);

					// ������ ��ᯮ�� dxBar_Integration
					AddTBItem(dxBar_Integration, dxContainer_Export, 57, '', True); // �뫮 dxBar_Options
					AddTBItem(dxBar_Integration, dxContainer_Import, 56); // �뫮 dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ImportInternal, ActionImport, dxContainer_Import); // �뫮 dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportInternal, ActionExport, dxContainer_Export); // �뫮 dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ImportXLS, ActionImportRAW, dxContainer_Import); // �뫮 dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportXLS, ActionExportXLS, dxContainer_Export); // �뫮 dxBar_Options

					// �����稬 ����⢨� ������� dxBar_Data
					AddTBItem(dxBar_Data, dxButton_PlansCompare, ActionPlansCompare);
					AddTBItem(
						dxBar_Data,
						dxButton_ZakonControl,
						ActionZakonControl,
						dxPopupMenu_ZakonControl,
						[ActionZControl, ActionCorrectControl, ActionTotalControl],
						'',
						[ivlLargeIconWithText]);

					AddTBItem(dxBar_Data, dxButton_Renum, ActionReNum, '', [], True);
					AddTBItem(dxBar_Data, dxButton_SetIDCode, ActionWriteValidIKZ);
					AddTBItem(dxBar_Data, dxButton_EditPositionXLS, ActionMultiEditXLS);
					AddTBItem(dxBar_Data, dxButton_EditPosition, ActionMultiEdit);
					AddTBItem(dxBar_Data, dxButton_SetPositionNoChanged, ActionClearChangedValue);
					AddTBItem(dxBar_Data, dxButton_ImportPGPosition, ActionImportFromPG);

					// ���� "������" - ������
					SetToolbarActive(dxBar_MainObjectActions, strRibbonToolbarPlanPosition);
					// ���� "����⥯����" - ����
					SetToolbarActive(dxBar_MinorObjectActions, strRibbonToolbarPlan);
					// ���� "����� ���" - ����� ���
					SetToolbarActive(dxBar_PrintForms, strRibbonToolbarPrintForms);
					// ���� "��⥣���" - ��⥣���
					SetToolbarActive(dxBar_Integration, strRibbonToolbarIntegration);
					// ���� "��ࢨ�" - �������⥫쭮
					SetToolbarActive(dxBar_Data, strRibbonToolbarService);
				end;
			end;
			{$ENDREGION}
		end;

		// ����������� Active=True ������ ���� ��᫥ EndUpdate ⠪ �먣�뢠�� 0.02�
		dxRibbon.EndUpdate;

		// ��᫥ ⮣� ��� �������� ����⢨� ���⠢���� �㦭� ����㧨�� �� ����ࠦ����
		LoadGlyphOnToolbars(dxRibbon_Actions);
	end;

	LastActiveWindowHandle := ActiveMDIChild.Handle;
	dxRibbon_Actions.Active := True;
end;