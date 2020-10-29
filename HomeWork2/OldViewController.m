//
//  OldViewController.m
//  HomeWork2
//
//  Created by Виталий Овсянников on 29.10.2020.
//

#import "OldViewController.h"

@interface OldViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wordsLabel;
@property (weak, nonatomic) IBOutlet UITextField *adderTextField;


@property (weak, nonatomic) IBOutlet UITextField *powerTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation OldViewController

NSString *words = @"";

- (IBAction)add:(UIButton *)sender {
    if ([words isEqual: @""]) {
        words = _adderTextField.text;
    } else {
        words = [words stringByAppendingFormat: @" %@", _adderTextField.text];
    }
    _wordsLabel.text = words;
}
- (IBAction)powerUp:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wordsLabel.text = @"Введите слова ниже";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
