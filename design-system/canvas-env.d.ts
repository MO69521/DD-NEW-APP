// 编辑器类型垫片：Cursor Canvas 运行时（cursor/canvas、react）由托管环境提供，
// 仓库内没有对应 npm 依赖。此声明仅用于让编辑器 TS 语言服务不报错，不影响 canvas 渲染。

declare module "react" {
  export type ReactNode = any;
  export type CSSProperties = any;
  export function useState<T>(
    initial: T | (() => T),
  ): [T, (value: T | ((prev: T) => T)) => void];
  const React: any;
  export default React;
}

declare module "react/jsx-runtime" {
  export const jsx: any;
  export const jsxs: any;
  export const Fragment: any;
}

declare module "cursor/canvas" {
  export const Stack: any;
  export const Row: any;
  export const Grid: any;
  export const H1: any;
  export const H3: any;
  export const Text: any;
  export const Code: any;
  export const Table: any;
  export const Callout: any;
  export const Divider: any;
  export const Pill: any;
  export const Stat: any;
  export const useHostTheme: any;
  export function useCanvasState<T>(
    key: string,
    initial: T,
  ): [T, (value: T | ((prev: T) => T)) => void];
  export function useCanvasAction(): (action: any) => void;
  export function mergeStyle(...styles: any[]): any;
}

declare namespace JSX {
  interface IntrinsicElements {
    [elemName: string]: any;
  }
  interface ElementChildrenAttribute {
    children: {};
  }
  type Element = any;
  type ElementClass = any;
}
