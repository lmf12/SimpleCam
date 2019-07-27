//
//  SCSettingViewController.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCAppSetting.h"
#import "SCSettingCell.h"
#import "SCSettingSectionModel.h"
#import "SCFaceDetectorManager.h"

#import "SCSettingViewController.h"

static NSString * const kReuseIdentifier = @"SCSettingCell";

// section ID
static NSString * const kSectionIDFace = @"SectionIDFace";

// model ID
static NSString * const kModelIDFacepp = @"ModelIDFacepp";
static NSString * const kModelIDOpenCV = @"ModelIDOpenCV";

@interface SCSettingViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    SCSettingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <SCSettingSectionModel *>*sections;

@end

@implementation SCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [self commonInit];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Private

- (void)commonInit {
    [self setupData];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.translucent = NO;
    [self setupCloseButton];
    [self setupTableView];
}

- (void)setupData {
    /// 人脸识别引擎
    SCSettingSectionModel *faceSection = [[SCSettingSectionModel alloc] init];
    faceSection.sectionID = kSectionIDFace;
    faceSection.sectionTitle = @"人脸识别引擎";
    // Face++
    SCSettingModel *faceppModel = [[SCSettingModel alloc] init];
    faceppModel.modelID = kModelIDFacepp;
    faceppModel.modelTitle = @"Face++（推荐）";
    faceppModel.isSwitchOn = [SCAppSetting isUsingFaceppEngine];
    @weakify(self);
    faceppModel.switchChangedAction = ^(BOOL isOn) {
        @strongify(self);
        SCFaceDetectorManager *manager = [SCFaceDetectorManager shareManager];
        if (isOn) {
            // 如果 OpenCV 使用中，则关闭 OpenCV
            if (manager.faceDetectMode == SCFaceDetectModeOpenCV) {
                [self changeModelStatusWithModelID:kModelIDOpenCV status:NO];
            }
            manager.faceDetectMode = SCFaceDetectModeFacepp;
        } else if (manager.faceDetectMode == SCFaceDetectModeFacepp) {
            manager.faceDetectMode = SCFaceDetectModeNone;
        }
    };
    // OpenCV
    SCSettingModel *openCVModel = [[SCSettingModel alloc] init];
    openCVModel.modelID = kModelIDOpenCV;
    openCVModel.modelTitle = @"OpenCV";
    openCVModel.isSwitchOn = [SCAppSetting isUsingOpenCVEngine];
    openCVModel.switchChangedAction = ^(BOOL isOn) {
        @strongify(self);
        SCFaceDetectorManager *manager = [SCFaceDetectorManager shareManager];
        if (isOn) {
            // 如果 Face++ 使用中，则关闭 Face++
            if (manager.faceDetectMode == SCFaceDetectModeFacepp) {
                [self changeModelStatusWithModelID:kModelIDFacepp status:NO];
            }
            manager.faceDetectMode = SCFaceDetectModeOpenCV;
        } else if (manager.faceDetectMode == SCFaceDetectModeOpenCV) {
            manager.faceDetectMode = SCFaceDetectModeNone;
        }
    };
    
    faceSection.models = @[faceppModel, openCVModel];
    self.sections = @[faceSection];
}

- (void)setupCloseButton {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_black"] forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(closeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SCSettingCell class] forCellReuseIdentifier:kReuseIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIView *)headViewWithSectionModel:(SCSettingSectionModel *)sectionModel {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = RGBA(155, 155, 155, 1);
    label.text = sectionModel.sectionTitle;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(10);
        make.left.equalTo(view).offset(20);
    }];
    
    return view;
}

// 通过 ID 来更改 cell 和 model 的状态
- (void)changeModelStatusWithModelID:(NSString *)modelID status:(BOOL)status {
    SCSettingModel *targetModel = nil;
    SCSettingSectionModel *targetSection = nil;
    for (SCSettingSectionModel *section in self.sections) {
        for (SCSettingModel *model in section.models) {
            if ([model.modelID isEqualToString:modelID]) {
                targetSection = section;
                targetModel = model;
                break;
            }
        }
    }
    if (targetModel) {
        targetModel.isSwitchOn = status;
        
        // 查找cell，如果展示中，则修改UI
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[targetSection.models indexOfObject:targetModel] inSection:[self.sections indexOfObject:targetSection]];
        SCSettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setOn:status];
    }
}

#pragma mark - Action

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section].models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    cell.model = self.sections[indexPath.section].models[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headViewWithSectionModel:self.sections[section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark - SCSettingCellDelegate

- (void)settingCell:(SCSettingCell *)settingCell didChangedWithModel:(SCSettingModel *)model {
    model.isSwitchOn = [settingCell isOn];
}

@end
