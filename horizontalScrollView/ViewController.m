//
//  ViewController.m
//  horizontalScrollView
//
//  Created by YiChe on 16/4/21.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewCell.h"
#import "XLPlainFlowLayout.h"
#import "CollectionReusableView.h"

static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const SupplementaryViewHeaderIdentify = @"CollectionReusableView";
static NSString * const SupplementaryViewLeftHeaderIdentify = @"SupplementaryViewLeftHeaderIdentify";
static NSString * const SupplementaryViewFooterIdentify = @"SupplementaryViewFooterIdentify";

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (strong, nonatomic) UICollectionView *headCollectionView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *leftCollectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger num;//列数
@property (strong, nonatomic) NSMutableArray *headViewArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 10;
    self.headViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    [self setupViews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = [UIColor colorWithRed:0.7232 green:1.0 blue:0.1588 alpha:1.0];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = 2;
    [addButton setTitle:@"加一列" forState:UIControlStateNormal];
    addButton.tag = [@"加一列" hash];
    addButton.frame = CGRectMake(10, 30, 80, 35);
    [addButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    decreaseButton.backgroundColor = [UIColor colorWithRed:0.7232 green:1.0 blue:0.1588 alpha:1.0];
    decreaseButton.layer.masksToBounds = YES;
    decreaseButton.layer.cornerRadius = 2;
    [decreaseButton setTitle:@"减一列" forState:UIControlStateNormal];
    decreaseButton.tag = [@"减一列" hash];
    decreaseButton.frame = CGRectMake(10, 75, 80, 35);
    [decreaseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:decreaseButton];
    
    /*
     * 左边CollectionView
     */
    XLPlainFlowLayout *leftLayout = [[XLPlainFlowLayout alloc] init];
    leftLayout.naviHeight = 0;
    leftLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect leftRect = CGRectMake(0, 120, 101, self.view.bounds.size.height-20-100);
    self.leftCollectionView = [[UICollectionView alloc] initWithFrame:leftRect collectionViewLayout:leftLayout];
    self.leftCollectionView.backgroundColor = [UIColor whiteColor];
    self.leftCollectionView.dataSource = self;
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.showsVerticalScrollIndicator = NO;
    self.leftCollectionView.scrollsToTop = NO;
    self.leftCollectionView.bounces = NO;
    //注册
    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellReuseIdentify];
    //UICollectionElementKindSectionHeader注册是固定的
    [self.leftCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewLeftHeaderIdentify];
    [self.view addSubview:self.leftCollectionView];
    
    /*
     * scrollView
     */
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(101, 20, [UIScreen mainScreen].bounds.size.width-101, self.view.bounds.size.height-20)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    CGFloat width = self.scrollView.bounds.size.width > (self.num*100+(self.num-1)*1)?self.scrollView.bounds.size.width:(self.num*100+(self.num-1)*1);
    /*
     * 顶部CollectionView
     */
    XLPlainFlowLayout *headLayout = [[XLPlainFlowLayout alloc] init];
    headLayout.naviHeight = 0;
    headLayout.minimumInteritemSpacing = 1;
    headLayout.minimumLineSpacing = 0;
    headLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect headRect = CGRectMake(0, 0, width, 100);
    self.headCollectionView = [[UICollectionView alloc] initWithFrame:headRect collectionViewLayout:headLayout];
    self.headCollectionView.backgroundColor = [UIColor whiteColor];
    self.headCollectionView.dataSource = self;
    self.headCollectionView.delegate = self;
    self.headCollectionView.showsVerticalScrollIndicator = NO;
    self.headCollectionView.scrollsToTop = NO;
    [self.headCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellReuseIdentify];
    [self.scrollView addSubview:self.headCollectionView];
    
    /*
     * 底部CollectionView
     */
    XLPlainFlowLayout *layout = [[XLPlainFlowLayout alloc] init];
    layout.naviHeight = 0;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect rect = CGRectMake(0, 100, width, self.scrollView.bounds.size.height-100);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellReuseIdentify];
    //UICollectionElementKindSectionHeader注册是固定的
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewHeaderIdentify];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewFooterIdentify];
    [self.scrollView addSubview:self.collectionView];
    self.scrollView.contentSize = CGSizeMake(rect.size.width, 0);
}

- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == [@"加一列" hash]) {
        self.num +=1;
    }else if (sender.tag == [@"减一列" hash]){
        self.num -=1;
        self.num = self.num<=1?1:self.num;
    }
    CGFloat width = self.scrollView.bounds.size.width > (self.num*100+(self.num-1)*1)?self.scrollView.bounds.size.width:(self.num*100+(self.num-1)*1);
    CGRect headRect = CGRectMake(0, 0, width, 100);
    self.headCollectionView.frame = headRect;
    CGRect rect = CGRectMake(0, 100, width, self.scrollView.bounds.size.height-100);
    self.collectionView.frame = rect;
    self.scrollView.contentSize = CGSizeMake(rect.size.width, 0);
    [self.collectionView reloadData];
    [self.headCollectionView reloadData];
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        CGFloat x = scrollView.contentOffset.x;
        for (CollectionReusableView *supplementaryView in self.headViewArray) {
            supplementaryView.labelLeft.constant = x;
        }
        return;
    }
    else if (scrollView == _leftCollectionView){
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.leftCollectionView.contentOffset.y);
        return;
    }else if (scrollView == _collectionView){
        self.leftCollectionView.contentOffset = CGPointMake(self.leftCollectionView.contentOffset.x, self.collectionView.contentOffset.y);
        return;
    }
    
}

#pragma mark - UICollectionViewDataSource method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.collectionView) {
        return 15;
    }else if (collectionView == self.leftCollectionView){
        return 15;
    }else if (collectionView == self.headCollectionView){
        return 1;
    }else{
        return 15;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.num;
    }else if (collectionView == self.leftCollectionView){
        return 1;
    }else if (collectionView == self.headCollectionView){
        return self.num;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentify forIndexPath:indexPath];
    if (collectionView == self.leftCollectionView) {
        cell.backgroundColor = [UIColor colorWithRed:0.2003 green:0.5623 blue:0.9989 alpha:1.0];
        cell.textLabel.text = [NSString stringWithFormat:@"行信息:%zd", indexPath.section+1];
    }else if (collectionView == self.collectionView) {
        cell.backgroundColor = [UIColor colorWithRed:0.4261 green:0.8096 blue:1.0 alpha:1.0];
        cell.textLabel.text = [NSString stringWithFormat:@"(%zd,%zd)", indexPath.section+1, indexPath.row+1];
    }else if (collectionView == self.headCollectionView) {
        cell.backgroundColor = [UIColor colorWithRed:0.4261 green:0.8096 blue:1.0 alpha:1.0];
        cell.textLabel.text = [NSString stringWithFormat:@"这是第%zd列", indexPath.row+1];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader] && collectionView == self.collectionView){
        CollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewHeaderIdentify forIndexPath:indexPath];
        supplementaryView.backgroundColor = [UIColor colorWithRed:0.9906 green:0.9329 blue:0.9945 alpha:1.0];
        supplementaryView.headWidth.constant = self.scrollView.bounds.size.width-1;
        supplementaryView.headLabel.text = [NSString stringWithFormat:@"这是第%ld行  ",indexPath.section+1];
        [self.headViewArray addObject:supplementaryView];
        return supplementaryView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionHeader] && collectionView == self.leftCollectionView){
        UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewLeftHeaderIdentify forIndexPath:indexPath];
        supplementaryView.backgroundColor = [UIColor colorWithRed:0.9906 green:0.9329 blue:0.9945 alpha:1.0];
        UILabel *label = [supplementaryView viewWithTag:[@"label" hash]];
        if (label) {
            label.text = @"";
        }else{
            label = [[UILabel alloc]initWithFrame:supplementaryView.bounds];
            label.tag = [@"label" hash];
        }
        label.text = [NSString stringWithFormat:@" 行信息"];
        [supplementaryView addSubview:label];
        return supplementaryView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewFooterIdentify forIndexPath:indexPath];
        supplementaryView.backgroundColor = [UIColor colorWithRed:0.6882 green:1.0 blue:0.6772 alpha:1.0];
        return supplementaryView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate method
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.268 blue:0.2644 alpha:1.0];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]
        || [NSStringFromSelector(action) isEqualToString:@"paste:"])
        return YES;
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    NSLog(@"复制之后，可以插入一个新的cell");
}


#pragma mark - UICollectionViewDelegateFlowLayout method
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return CGSizeMake(0, 30);
    }else if (collectionView == self.leftCollectionView){
        return CGSizeMake(0, 30);
    }else if (collectionView == self.headCollectionView){
        return CGSizeZero;
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.leftCollectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 1);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


@end
