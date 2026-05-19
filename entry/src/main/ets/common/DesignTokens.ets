/*
 * Design Tokens — 统一视觉设计系统
 *
 * 使用方式：在组件中 import 对应常量，
 * 避免硬编码色值/圆角/间距。
 *
 * 如需修改设计语言，只改此文件即可全局生效。
 */

/* ========== 主色 Primary ========== */
export const COLOR_PRIMARY = '#147C78';
export const COLOR_PRIMARY_HOVER = '#0F6764';
export const COLOR_PRIMARY_SOFT = '#DFF2F0';
export const COLOR_PRIMARY_PALE = '#F0F9F8';

/* ========== 背景 Surface ========== */
export const COLOR_BG = '#F5F7F8';
export const COLOR_SURFACE = '#FFFFFF';
export const COLOR_SURFACE_2 = '#EEF4F3';
export const COLOR_SURFACE_3 = '#F8FAFA';

/* ========== 文字 Text ========== */
export const COLOR_TEXT_PRIMARY = '#182326';
export const COLOR_TEXT_BODY = '#334247';
export const COLOR_TEXT_MUTED = '#667579';
export const COLOR_TEXT_PLACEHOLDER = '#9AA7AA';
export const COLOR_TEXT_ON_PRIMARY = '#FFFFFF';

/* ========== 描边 Line ========== */
export const COLOR_LINE = '#DCE5E4';
export const COLOR_LINE_LIGHT = '#E8EFEE';

/* ========== 阴影 Shadow ========== */
// 暂不导出，ArkUI 中 shadow 需要直接传参

/* ========== 圆角 Radius ========== */
export const RADIUS_SM = 8;
export const RADIUS_MD = 12;
export const RADIUS_LG = 20;
export const RADIUS_XL = 28;

/* ========== 间距 Spacing ========== */
// 使用 ArkUI 自身的 margin/padding API，暂不导出常量
