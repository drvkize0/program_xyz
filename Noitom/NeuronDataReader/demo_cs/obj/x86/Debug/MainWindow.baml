   M S B A M L   `   `   `  ����  demo_cs    demo_cs.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   -   5          � Title$'  !demo for NeuronDataReader library��5   	   $	��454��63   $	��525��6@   .��5      � .+�5   
   �� -   5        $��txtLog��5      $��0��6"   $��10,97,265,0q�6+    �� TextAlignment$ Center=�6@   $��28��6W   $	��Top=�6c   $��18(�6{   $
��Bold"�6�   �� 5   
   -   5        $��txtLog1��5      $��0��6#   $��10,127,265,0q�6,   $ Center=�6B   $��28��6Y   $	��Top=�6e   $��18(�6}   $
��Bold"�6�   �� 5   
   $��10,10,265,185q�6   $
��Auto=�6.   .��5	      �� -   5        $��txtCommandLog��5	      5
      �� 5   
   $��	0,10,10,0q�6   $��TCP/IP Testing��6&   $��Right=�6>   $	��250��6Z   $	��124��6f   $	��Top=�6s   .��5      � .+�5      �� $
��Left=�6   $
��Wrap=�67   $��
Server IP:��6K   $	��Top=�6]   $��	33,17,0,0q�6u   �� 5      $
��Left=�6   $
��Wrap=�67   $��Server Port:��6K   $	��Top=�6_   $��	20,47,0,0q�6w   �� 5      -   5        $��txtIP��5      $
��Left=�6'   $��23��6B   $��	91,15,0,0q�6N    �� TextWrapping$
 Wrap=�6a   $��	127.0.0.1��6u   $	��Top=�6�   $	��120��6�   �� 5      -   5        $��txtPort��5      $
��Left=�6)   $��23��6D   $��	91,45,0,0q�6P   $
 Wrap=�6c   $
��7001��6w   $	��Top=�6�   $	��120��6�   �� 5      -   5        $��
btnConnect��5      $��Connect��6+   $
��Left=�6=   $��	91,76,0,0q�6X   $	��Top=�6k   $��75��6�   6�   �� 5      -   5        $��
txtSockLog��5      $��45,225,0,10q�6.   $
��Wrap=�6C   5      5      �� 5   
   $��
0,289,10,0q�6   $��UDP Testing��6'   $��Right=�6=   $	��250��6Y   $	��124��6e   $	��Top=�6r   .��5      � .+�5      �� $
��Left=�6   $
��Wrap=�67   $��Listenning at:��6K   $	��Top=�6a   $��	10,16,0,0q�6y   �� 5      -	   5        $��
txtUDPPort��5      $
��Left=�6,   $��23��6G   $��	91,14,0,0q�6S   $
 Wrap=�6f   $
��7001��6z   $	��Top=�6�   $	��120��6�   �� 5      -
   5        $��btnStartUDPService��5      $��Start��63   $
��Left=�6C   $��	91,42,0,0q�6^   $	��Top=�6q   $��75��6�   6�   �� 5      -   5        $��txtUDPServiceStatus��5      $��45,225,0,10q�67   $
��Wrap=�6L   5      5      �� 5    
   $
��Left=�6   $��	8,0,0,163q�6/   $��17��6B   $��Bottom=�6N   Commands test:6z   �� 5!   
   -   5         ��Name$ btnCmdFetches��5!      $��Fetch��6(   $
��Left=�68   $��161,0,0,129q�6S   $��68��6h   $��19��6�   $��Bottom=�6�   �� 5"   
   -   5         ��Name$ cbFetchCommand��5"      $
��Left=�6+   $��
24,0,0,129q�6F   $	��132��6Z   $��21��6�   $��Bottom=�6�    �� SelectedIndex$ 0��6�   .@�5#      �� .��6   Bone dimention6+   �� 5$      .��6   Face direction6+   �� 5%      .��6   Avatar name6(   �� 5&      .��6   Data Frequency6+   �� 5'      .��6   Bvh Inheritance6,   �� 5(      .��6   Avatar count6)   �� 5)      .��6   	Comb mode6&   5*      �� 5,   
   $
��Left=�6   $��8,0,0,84q�6/   $��17��6A   $��Bottom=�6M   Received data information:6�   �� 5-   
   -   5        $��
cbWithDisp��5-      $��With displement��6%   $
��Left=�6?   $��	29,0,0,54q�6Z   {�.   d� 	IsChecked$
 TrueY�6   $��15��6�   $��Bottom=�6�   �� 5.   
   -   5        $��cbWithPrefix��5.      $��With prefix��6'   $
��Left=�6=   $��	29,0,0,25q�6X   {�.  $��15��6}   $��Bottom=�6�   �� 5/   
   $��
0,145,10,0q�6   $��Right=�6'   $	��250��6C   $	��124��6O   $	��Top=�6\   $��TCP/IP Testing 2��6t   .��50      � .+�51      �� $
��Left=�6   $
��Wrap=�67   $��
Server IP:��6K   $	��Top=�6]   $��	33,17,0,0q�6u   �� 52      $
��Left=�6   $
��Wrap=�67   $��Server Port:��6K   $	��Top=�6_   $��	20,47,0,0q�6w   �� 53      -   5         ��Name$ txtIP1��53      $
��Left=�6*   $��23��6E   $��	91,15,0,0q�6Q   $
 Wrap=�6d   $��192.168.2.41��6x   $	��Top=�6�   $	��120��6�   �� 54      -   5        $ txtPort1��54      $
��Left=�6,   $��23��6G   $��	91,45,0,0q�6S   $
 Wrap=�6f   $
��7001��6z   $	��Top=�6�   $	��120��6�   �� 55      -   5        $ btnConnect1��55      $��Connect��6.   $
��Left=�6@   $��	91,76,0,0q�6[   $	��Top=�6n   $��75��6�   6�   �� 56      -   5         ��Name$ txtSockLog1��56      $��45,225,0,10q�61   $
��Wrap=�6F   57      58      59      5:      