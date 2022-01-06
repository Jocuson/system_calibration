## 仿真计算aber_phase

1. 随意给定zernike系数a1,...,a12(只用4~12阶)，调用SH.m方法，生成一个仿真aber_phase1. (init_zernike.m)
2. 利用aber_phase1生成一个带相差的psf
3. 构造一个理论的样本（球体），利用2的psf做forward projection生成WDF
   - 整个球体分为101层，中间可以创建51层球面，用实心球，球半径不宜过大，层size可以设置为1815*1815
   - 前向投影得到额WDF结果与球体size一致，可以resize到363*363
4. 用WDF计算map_wavshape,然后估算出 calcu_phase,计算时系数先设为1，然后用这个拟合计算出新的zernike系数 (拟合出zernike系数，b1,....,b12)
   - 用WDF计算出偏移相差数据shift_map，为15\* 15 \* 2矩阵
   - 在estimate_zernike中用shift_map 计算出calcu_phase，在calcu_phase_k计算中将系数先置为1，用lsqcurvefit拟合得到新的a1，标记为b1
5. .线性拟合a和b，使得a(0,15)=kb(0,15)  用直线最小二乘法拟合k，这个k带入calcu_phase_k =  k \* *calcu_phase\.\*mask; 
   - 使用直线最小二乘法得到系数 k ,matlab方法polyfit(b1,a1,1)
6. k代入原有代码，用实采的WDF（棋盘格）算出实际aber_phase，最后算出真实像差的psf
   - estimate_zernike.m
   - load 棋盘格WDF计算得到的shift_map
   - calcu_phase_k = k\* calcu_phase\.\*mask; 将前面计算得到的k带入
   - 计算得到aber_phase，并带入psf生成代码生成相应代码