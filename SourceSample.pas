// Часть кода была умышленно вырезана, чтобы не возникало проблем с разглашением исходников
// Данный код был написан с настройками редактора Delphi:
// Block indent = 2
// Tab Stop = 2.
// Use tab character - включен
// Right margin = 140
// При таких параметрах выравнивания в коде должны выглядеть одинаково аккуратно по всему коду

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
		// Нужно установить видимость тулбару на открываемой форме
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
	// Если окно с тулбаром, устанавливаем видимость тулбаров на форме
	if (ActiveMDIChild is TMDIFormTB) and (ActiveMDIChild.ClassName <> str_Desktop) then
	begin
		FormID := TActionToolbarWindow(GetClassIndex(ActiveMDIChild.ClassName));
	end
	else
	begin
		// Этот блок происходит только в случае когда показывается окно без тулбаров(один лишь dxBar_ScreenSpace)
		// Прежде чем очистим тулбары, перейдем на предыдущую вкладку(не будем переходить на закладку действий)
		dxRibbon.ActiveTab := LastRibbonTab;
		ClearToolbars(dxRibbon_Actions);

		if Assigned(ActiveMDIChild) and (ActiveMDIChild.ClassName <> str_Desktop) then
			LastActiveWindowHandle := ActiveMDIChild.Handle
		else
			LastActiveWindowHandle := 0;

		Exit;
	end;

	// Оптимизация 3. Если тулбар уже нарисован (пользователь перешел на закладку действия сам)
	if LastActiveWindowHandle <> ActiveMDIChild.Handle then
	begin
		// Скроем все содержимое
		// Оптимизация 1.
		// Нужно обязательно сначала скрыть все содержимое закладки, от крупного к мелким, чтобы иключить перерисовку
		ClearToolbars(dxRibbon_Actions);

		dxRibbon.BeginUpdate;
		SetToolBarYearVisible;

		// СПРАВКА: порядок вызова SetToolbarActive не определяет порядок отображения тулбаров слева направо
		// их порядок задан изначально на главной форме на риббоне. SetToolbarActive регулируют только видимость
		case FormID of
			{$REGION ' atwOwners '}
			atwOwners:
			begin
				with (ActiveMDIChild as TfrmGZOwners) do
				begin
					// Оптимизация 2.
					// Сначала назначим видимость кнопкам на невидимом тулбаре, и только в конце покажем тулбары
					// Назначим действия кнопкам dxBar_MainObjectActions
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
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNotices223, ActionViewNotices223); // Извещения 223 еще не готовы

						AddTBItem(
							dxBar_MultiZakup,
							dxButton_MultiReestr,
							ActionViewReestr,
							dxPopupMenu_MultiReestr,
							[ActionViewSpec, ActionViewOplat, ActionViewNotReestr{, ActionViewNotices223}],
							'',
							[],
							True); // Извещения 223 еще не готовы

						AddTBItem(dxBar_MultiZakup, dxContainer_MultiLimits, 24);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiLimitFin, ActionLimitsFin, dxContainer_MultiLimits);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiLimitAnalys, ActionLimitAnalize, dxContainer_MultiLimits);

						AddTBItem(dxBar_MultiZakup, dxContainer_MultiHelpers, 83);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK, ActionViewCenaAccount, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK102, ActionViewNMCK102, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiNMCK871, ActionViewCenaAccount871, dxContainer_MultiHelpers);
						AddTBItem(dxBar_MultiZakup, dxButton_MultiGRLS, ActionViewGRLS, dxContainer_MultiHelpers);
					{$ENDIF}

					// Назначим действия кнопкам dxBar_Integration
					AddTBItem(dxBar_Integration, dxButton_ImportFromPortal, ActionImportFromOOS, '', [ivlLargeIconWithText]);

					// Назначим действия кнопкам dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportXLS, ActionExport, '', [], True); // Одиночная кнопка без выпадающего списка;
					AddTBItem(dxBar_Integration, dxButton_ImportXLS, ActionImport); // Одиночная кнопка без выпадающего списка;

					{$IFDEF MULTI_OWNERS}
					AddTBItem(dxBar_Data, dxButton_CheckActual, ActionCheckActual);
					AddTBItem(dxBar_Data, dxButton_NoticeSchedule, ActionNoticeSchedule);
					{$ENDIF}

					// Назначим действия кнопкам dxBar_Data
					AddTBItem(dxBar_Data, dxButton_Plan, ActionCheckInRNP);
					AddTBItem(dxBar_Data, dxButton_Notice, ActionCheckInSMP);

					// Блок "Главный" - Организация
					SetToolbarActive(dxBar_MainObjectActions, strRibbonToolbarOrg);

					{$IFDEF MULTI_OWNERS}
						// Блок "Закупки по организации" - Закупки по организации
						SetToolbarActive(dxBar_MultiZakup, strRibbonToolbarMultiZakup);
					{$ENDIF}

					// Блок "Интеграция" - Интеграция
					SetToolbarActive(dxBar_Integration, strRibbonToolbarIntegration);

					// Блок "Сервис" - Данные реестра
					SetToolbarActive(dxBar_Data, strRibbonToolbarService);
				end;
			end;
			{$ENDREGION}

			{$REGION ' atwPlanZakup44 '}
			atwPlanZakup44:
			begin
				with (ActiveMDIChild as TfrmPlanZakup) do
				begin
					// Назначим действия кнопкам dxBar_MainObjectActions
					AddTBItem(dxBar_MainObjectActions, dxButton_New, ActionNew, dxPopupMenu_Copy, ActionCopy, strRibbonActionNew);
					AddTBItem(dxBar_MainObjectActions, dxButton_Property, ActionEdit);
					AddTBItem(dxBar_MainObjectActions, dxButton_Delete, ActionDelete);
					AddTBItem(dxBar_MainObjectActions, dxButton_Refresh, ActionRefresh);
					AddTBItem(dxBar_MainObjectActions, dxButton_Search, ActionFind);
					AddTBItem(dxBar_MainObjectActions, dxButton_Filter, ActionFilter);

					// Назначим действия кнопкам dxBar_MinorObjectActions
					AddTBItem(dxBar_MinorObjectActions, dxButton_MinorNew, ActionNewPlan, strRibbonActionNewPlan);
					AddTBItem(
						dxBar_MinorObjectActions, dxButton_MinorProperty, ActionEditPlan, strRibbonActionEditPlan);
					AddTBItem(
						dxBar_MinorObjectActions, dxButton_MinorDelete, ActionDeletePlan, strRibbonActionDeletePlan);

					// Назначим действия кнопкам dxBar_PrintForms
					AddTBItem(dxBar_PrintForms, dxButton_XLSForm, ActionPrintXLSForm);
					AddTBItem(dxBar_PrintForms, dxButton_Rational, ActionSolutionForm);

					// Назначим действия кнопкам dxBar_Integration
					AddTBItem(dxBar_Integration, dxButton_ExportToPortal, ActionExportXLS4OOS, '', [ivlLargeIconWithText]);
					AddTBItem(dxBar_Integration, dxButton_ImportFromPortal, ActionImportFromOOS,  '', [ivlLargeIconWithText]);

					// Импорт экспорт dxBar_Integration
					AddTBItem(dxBar_Integration, dxContainer_Export, 57, '', True); // было dxBar_Options
					AddTBItem(dxBar_Integration, dxContainer_Import, 56); // было dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ImportInternal, ActionImport, dxContainer_Import); // было dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportInternal, ActionExport, dxContainer_Export); // было dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ImportXLS, ActionImportRAW, dxContainer_Import); // было dxBar_Options
					AddTBItem(dxBar_Integration, dxButton_ExportXLS, ActionExportXLS, dxContainer_Export); // было dxBar_Options

					// Назначим действия кнопкам dxBar_Data
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

					// Блок "Главный" - Позиция
					SetToolbarActive(dxBar_MainObjectActions, strRibbonToolbarPlanPosition);
					// Блок "Второстепенный" - План
					SetToolbarActive(dxBar_MinorObjectActions, strRibbonToolbarPlan);
					// Блок "Печатные формы" - Печатные формы
					SetToolbarActive(dxBar_PrintForms, strRibbonToolbarPrintForms);
					// Блок "Интеграция" - Интеграция
					SetToolbarActive(dxBar_Integration, strRibbonToolbarIntegration);
					// Блок "Сервис" - Дополнительно
					SetToolbarActive(dxBar_Data, strRibbonToolbarService);
				end;
			end;
			{$ENDREGION}
		end;

		// ОПТИМИЗАЦИЯ Active=True должен быть после EndUpdate так выигрываем 0.02с
		dxRibbon.EndUpdate;

		// После того как закладка действий доставлена нужно загрузить им изображения
		LoadGlyphOnToolbars(dxRibbon_Actions);
	end;

	LastActiveWindowHandle := ActiveMDIChild.Handle;
	dxRibbon_Actions.Active := True;
end;